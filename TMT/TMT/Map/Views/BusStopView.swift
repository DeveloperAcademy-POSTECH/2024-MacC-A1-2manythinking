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
    var longtitude: Double
}

struct BusStopView: View {
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
                ThisStopView(stopNameKorean: journeyModel.journeyStops[passedStops].stopNameKorean ?? "", stopNameNaver: journeyModel.journeyStops[passedStops].stopNameNaver ?? "", stopNameRomanized: journeyModel.journeyStops[passedStops].stopNameRomanized ?? "")
                
                HStack {
                    Spacer()
                    
                    controlsView
                        .padding(.trailing, 15.48)
                        .padding(.top, 23.91)
                }
                
                Spacer()
                
                EndStopView(endStop: journeyModel.journeyStops.last?.stopNameNaver ?? "", remainingStops: locationManager.remainingStops)
            }
        }
        .onAppear {
            if locationManager.isFirstLoad {
                locationManager.findCurrentLocation()
            }
            
            searchModel.searchBusStops(byNumber: journeyModel.journeyStops.first?.busNumber ?? "")
            coordinatesList = getValidCoordinates()
        }
        // TODO: 실제로 줄어드는지 테스트 필요
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
                    .tint(Color.Basic.grey70)
                
                Image(systemName: "location.fill")
                    .tint(Color.Basic.yellow500)
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
