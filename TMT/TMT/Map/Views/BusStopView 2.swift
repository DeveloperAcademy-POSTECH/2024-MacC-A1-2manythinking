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
    var longtitude: Double
}

struct BusStopView2: View {
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var searchModel: BusSearchModel
    @EnvironmentObject var journeyModel: JourneySettingModel
    @State private var coordinatesList: [Coordinate] = []
    @State private var passedStops: Int = 0
    
    var body: some View {
        ZStack {
            busStopViewWrapper
                .edgesIgnoringSafeArea(.vertical)
            
            VStack {
                EndStopView2(endStopNameKorean: journeyModel.journeyStops.last?.stopNameKorean ?? "", endStopNameRomanized: journeyModel.journeyStops.last?.stopNameRomanized ?? "", endStopNameNaver: journeyModel.journeyStops.last?.stopNameKorean ?? "", remainingStops: locationManager.remainingStops)
                    .padding(.top, 17.04)
                Spacer()
                HStack {
                    Spacer()
                    controlsView
                        .padding(.trailing, 18.25)
                }
                // TODO: bottom sheet 또는 선택된 정류장 정보 뷰 들어가야함.
            }
        }
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
        BusStopViewWrapper(region: $locationManager.region, coordinatesList: coordinatesList)
    }
    
    private var controlsView: some View {
        Button {
            locationManager.findCurrentLocation()
        } label: {
            ZStack {
                Circle()
                    .frame(width: 44, height: 44)
                    .foregroundStyle(.basicWhite)
                
                Image(systemName: "location.fill")
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
            return Coordinate(latitude: latitude, longtitude: longitude)
        }
    }
}
