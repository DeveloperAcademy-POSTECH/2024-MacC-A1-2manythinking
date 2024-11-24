//
//  MapView.swift
//  TMT
//
//  Created by Choi Minkyeong on 10/15/24.
//

import SwiftUI

struct Coordinate: Identifiable {
    var id = UUID()
    var latitude: Double
    var longitude: Double
}

struct MapView: View {
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var searchModel: BusSearchModel
    @EnvironmentObject var journeyModel: JourneySettingModel
    @StateObject var selectedStopManager = SelectedStopManager()
    @EnvironmentObject var activityManager: LiveActivityManager
    @EnvironmentObject var imageHandler: ImageHandlerModel
    
    @State private var coordinatesList: [Coordinate] = []
    @State private var passedStops: Int = 0
    @State private var isUpdateRequested = false
    @State private var isShowingBottomSheet = true
    
    @Binding var path: [String]
    
    var body: some View {
        ZStack {
            busStopViewWrapper
                .edgesIgnoringSafeArea(.vertical)
            
            VStack {
                EndStopView(endStopNameKorean: journeyModel.journeyStops.last?.stopNameKorean ?? "",
                            endStopNameRomanized: journeyModel.journeyStops.last?.stopNameRomanized ?? "",
                            endStopNameNaver: journeyModel.journeyStops.last?.stopNameKorean ?? "",
                            remainingStops: locationManager.remainingStops)
                .padding([.top, .leading], 16)
                .padding(.trailing, 17)
                
                Spacer()
                
                HStack {
                    Spacer()
                    
                    myLocationButton
                        .padding(.trailing, 30)
                        .padding(.bottom, 120)
                }
                
                if selectedStopManager.isTapped == true {
                    SelectedBusStopView()
                }
            }
        }
        // TODO: 바텀시트 수정하기. 디테일 잡기
        // TODO: 제일 작은 사이즈일 때는 정류장 안 보이도록 수정하기.
        .bottomSheet(isPresented: $isShowingBottomSheet) {
            sheetView
        }
        .environmentObject(selectedStopManager)
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            if locationManager.isFirstLoad {
                locationManager.findCurrentLocation()
            }
            searchModel.searchBusStops(byNumber: journeyModel.journeyStops.first?.busNumber ?? "")
            coordinatesList = getValidCoordinates()
        }
        .onChange(of: locationManager.remainingStops) {
            passedStops = journeyModel.journeyStops.count - locationManager.remainingStops
        }
    }
    
    // MARK: - Views / Map
    private var busStopViewWrapper: some View {
        MapViewWrapper(selectedStopManager: selectedStopManager, region: $locationManager.region, isUpdateRequested: $isUpdateRequested, coordinatesList: coordinatesList)
    }
    
    private var myLocationButton: some View {
        Button {
            locationManager.findCurrentLocation()
            isUpdateRequested = true
        } label: {
            Circle()
                .frame(width: 44, height: 44)
                .foregroundStyle(.basicWhite)
                .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 2)
                .overlay {
                    Image(systemName: "location.fill")
                        .foregroundStyle(.yellow500)
                }
        }
    }
    
    // MARK: - Views / Bottom Sheet
    private var sheetView: some View {
        VStack(spacing: 3) {
            Rectangle()
                .frame(height: 100)
                .foregroundStyle(.basicWhite)
                .shadow(color: .basicBlack.opacity(0.25), radius: 2.5, y: 2)
                .overlay {
                    HStack(alignment: .bottom, spacing: 6) {
                        Text("\(locationManager.remainingStops)")
                            .font(.system(size: 45))
                        
                        Text("Stops Left")
                            .font(.system(size: 20))
                        
                        Spacer()
                        
                        endButton
                    }
                    .padding(.top, 26)
                    .padding(.horizontal, 35)
                    .padding(.bottom, 32)
                }
            
            BusStopsSheetView()
        }
    }
    
    private var endButton: some View {
        Button {
            activityManager.endLiveActivity()
            imageHandler.selectedImage = nil
            isShowingBottomSheet = false
            path.removeAll()
        } label: {
            Text("End")
                .foregroundStyle(.basicWhite)
                .frame(width: 69, height: 38)
                .background {
                    RoundedRectangle(cornerRadius: 30)
                        .foregroundStyle(.brandPrimary)
                }
        }
    }
    
    // MARK: - logic
    /// 좌표의 옵셔널을 제거합니다.
    private func getValidCoordinates() -> [Coordinate] {
        searchModel.filteredBusDataForNumber.compactMap { stop in
            guard let latitude = stop.latitude,
                  let longitude = stop.longitude else {
                return nil
            }
            return Coordinate(latitude: latitude, longitude: longitude)
        }
    }
}

#Preview {
    // Mock 데이터 및 객체 초기화
    let searchModel = BusSearchModel()
    let journeyModel = JourneySettingModel(searchModel: searchModel)
    let activityManager = LiveActivityManager()
    let imageHandler = ImageHandlerModel()
    let locationManager = LocationManager(activityManager: activityManager, journeyModel: journeyModel)
    
    searchModel.filteredBusDataForNumber = BusStop.busStopDummy
    
    journeyModel.journeyStops = BusStop.journeyStopDummy
    
    return MapView(path: .constant([]))
        .environmentObject(locationManager)
        .environmentObject(searchModel)
        .environmentObject(journeyModel)
        .environmentObject(activityManager)
        .environmentObject(imageHandler)
}
