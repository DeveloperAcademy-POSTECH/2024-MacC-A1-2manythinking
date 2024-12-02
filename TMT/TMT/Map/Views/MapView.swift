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
    
    @State private var colors: (statusColor: Color, leftStopNumberColor: Color, destinationColor: Color) = (.white, .white, .white)
    @State private var coordinatesList: [Coordinate] = []
    @State private var endStop: BusStop = BusStop()
    @State private var isShowingBottomSheet = true
    @State private var isUpdateRequested = false
    @State private var showingAlert: Bool = false
    @State private var tappedStop: BusStop = BusStop()
    @State private var tappedViewSize: CGSize = .zero
    
    @Binding var path: [String]
    
    var body: some View {
        ZStack {
            mapViewWrapper
                .edgesIgnoringSafeArea(.vertical)
            
            if selectedStopManager.isTapped {
                Color.black.opacity(0)
                    .ignoresSafeArea()
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedStopManager.isTapped = false
                    }
                TappedStopView(tappedStop: $tappedStop, tappedViewSize: $tappedViewSize)
                    .offset(
                        x: 0,
                        y: tappedViewSize.height / 2 + 19
                    )
                    .transition(.scale)
                    .animation(.spring(), value: selectedStopManager.isTapped)
            }
            
            VStack {
                EndStopView(busStopDetail: $endStop, colors: $colors, remainingStops: locationManager.remainingStops)
                    .padding([.top, .leading], 16)
                    .padding(.trailing, 17)
                
                Spacer()
                
                HStack {
                    Spacer()
                    
                    myLocationButton
                        .padding(.trailing, 30)
                        .padding(.bottom, 120)
                }
            }
            
            if !isShowingBottomSheet {
                popupView
            }
        }
        .environmentObject(selectedStopManager)
        // TODO: 바텀시트 수정하기. 디테일 잡기
        // TODO: 제일 작은 사이즈일 때는 정류장 안 보이도록 수정하기.
        .bottomSheet(isPresented: $isShowingBottomSheet) {
            sheetView
        }
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            if locationManager.isFirstLoad {
                locationManager.findCurrentLocation()
            }
            searchModel.searchBusStops(byNumber: journeyModel.journeyStops.first?.busNumber ?? "")
            coordinatesList = getValidCoordinates()
            endStop = journeyModel.journeyStops.last ?? BusStop()
            colors = mainColor(remainingStops: locationManager.remainingStops)
        }
        .onChange(of: locationManager.remainingStops) {
            colors = mainColor(remainingStops: locationManager.remainingStops)
            if locationManager.remainingStops == 0 {
                NotificationManager.shared.scheduleBusArrivalNotification()
                isShowingBottomSheet = false
            }
        }
    }
    // MARK: - Views / Map
    private var mapViewWrapper: some View {
        MapViewWrapper(selectedStopManager: selectedStopManager, isUpdateRequested: $isUpdateRequested, region: $locationManager.region, coordinatesList: coordinatesList)
    }
    
    private var myLocationButton: some View {
        Button {
            locationManager.findCurrentLocation()
            isUpdateRequested = true
        } label: {
            Circle()
                .frame(width: 44, height: 44)
                .foregroundStyle(.brandBackground)
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
                .foregroundStyle(.brandBackground)
                .shadow(color: .basicBlack.opacity(0.25), radius: 2.5, y: 2)
                .overlay {
                    HStack(alignment: .bottom, spacing: 6) {
                        Text("\(locationManager.remainingStops)")
                            .foregroundStyle(colors.leftStopNumberColor)
                            .font(.system(size: 45, weight: .semibold))
                        
                        Text("Stops Left")
                            .foregroundStyle(.grey200)
                            .font(.system(size: 20, weight: .bold))
                        
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
            showingAlert = true
        } label: {
            Text("End")
                .foregroundStyle(.brandBackground)
                .frame(width: 69, height: 38)
                .background {
                    RoundedRectangle(cornerRadius: 30)
                        .foregroundStyle(.brandPrimary)
                }
        }
        .alert("End Navigation", isPresented: $showingAlert) {
            Button("Stay", role: .cancel) {
                showingAlert = false
            }
            Button("End", role:.destructive) {
                activityManager.endLiveActivity(destinationInfo: journeyModel.journeyStops.last!)
                imageHandler.selectedImage = nil
                isShowingBottomSheet = false
                path.removeAll()
            }
        } message: {
            Text("Are you sure you want to return to Home? Your navigation will end.")
        }
    }
    
    private var popupView: some View {
        ZStack {
            Color.basicBlack.opacity(0.63)
                .ignoresSafeArea()
            BusStopArrivalView(hasNotArrived: $isShowingBottomSheet, path: $path)
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
    
    /// EndStopView의 메인 컬러를 판단합니다.
    private func mainColor(remainingStops: Int) -> (statusColor: Color, leftStopNumberColor: Color, destinationColor: Color) {
        let status = StopStatusEnum(remainingStops: remainingStops)
        return (status.statusColor, status.leftStopNumberColor, status.destinationColor)
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
