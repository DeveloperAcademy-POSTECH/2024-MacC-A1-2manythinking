//
//  BusStopView.swift
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

struct BusStopView: View {
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var searchModel: BusSearchModel
    @EnvironmentObject var journeyModel: JourneySettingModel
    @StateObject var selectedStopManager = SelectedStopManager()
    @EnvironmentObject var activityManager: LiveActivityManager
    @EnvironmentObject var imageHandler: ImageHandlerModel
    
    @State private var coordinatesList: [Coordinate] = []
    @State private var passedStops: Int = 0
    @State private var isUpdateRequested: Bool = false
    @Binding var path: [String]
    
    var body: some View {
        ZStack {
            busStopViewWrapper
                .edgesIgnoringSafeArea(.vertical)
            VStack {
                EndStopView(endStopNameKorean: journeyModel.journeyStops.last?.stopNameKorean ?? "", endStopNameRomanized: journeyModel.journeyStops.last?.stopNameRomanized ?? "", endStopNameNaver: journeyModel.journeyStops.last?.stopNameKorean ?? "", remainingStops: locationManager.remainingStops)
                    .padding(.top, 16)
                    .padding(.leading ,16)
                    .padding(.trailing, 17)
                Spacer()
                endButton // bottom sheet 적용되면 삭제될 예정
                HStack {
                    Spacer()
                    controlsView
                        .padding(.trailing, 28)
                        .padding(.bottom, 19.64)
                }
                if selectedStopManager.isTapped == true {
                    SelectedBusStopView()
                }
            }
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
    
    private var busStopViewWrapper: some View {
        BusStopViewWrapper(selectedStopManager: selectedStopManager, region: $locationManager.region, isUpdateRequested: $isUpdateRequested, coordinatesList: coordinatesList)
    }
    
    private var controlsView: some View {
        Button {
            locationManager.findCurrentLocation()
            isUpdateRequested = true
        } label: {
            Image(systemName: "location.fill")
                .foregroundStyle(.yellow500)
                .background {
                    Circle()
                        .frame(width: 44, height: 44)
                        .foregroundStyle(.basicWhite)
                        .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 2)
                }
        }
    }
    
    // 임의로 버튼을 만들어 놓았습니다. 추후 bottom sheet에 적용될 예정입니다.
    private var endButton: some View {
        Button {
            activityManager.endLiveActivity()
            imageHandler.selectedImage = nil
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
    
    return BusStopView(path: .constant([]))
        .environmentObject(locationManager)
        .environmentObject(searchModel)
        .environmentObject(journeyModel)
        .environmentObject(activityManager)
        .environmentObject(imageHandler)
}
