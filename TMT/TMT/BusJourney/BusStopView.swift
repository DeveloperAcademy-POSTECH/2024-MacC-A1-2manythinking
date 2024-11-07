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

struct BusStopView: View {
    @EnvironmentObject var locationManager: LocationManager
        @EnvironmentObject var busStopSearchViewModel: BusSearchViewModel
    @State private var coordinatesList: [Coordinate] = []
    @State private var passedStops: Int = 0
    
    var body: some View {
        ZStack {
            busStopViewWrapper
                .edgesIgnoringSafeArea(.vertical)
            VStack {
                ThisStopView(stopNameKorean: busStopSearchViewModel.journeyStops[passedStops].stopNameKorean ?? "", stopNameNaver: busStopSearchViewModel.journeyStops[passedStops].stopNameNaver ?? "", stopNameRomanized: busStopSearchViewModel.journeyStops[passedStops].stopNameRomanized ?? "")
                HStack {
                    Spacer()
                    controlsView
                        .padding(.trailing, 15.48)
                        .padding(.top, 23.91)
                }
                Spacer()
                    EndStopView(endStop: busStopSearchViewModel.journeyStops.last?.stopNameNaver ?? "", remainingStops: busStopSearchViewModel.remainingStops)
                
            }
        }
        .onAppear {
            if locationManager.isFirstLoad {
                locationManager.findCurrentLocation()
            }
            busStopSearchViewModel.searchBusStops(by: busStopSearchViewModel.journeyStops.first?.busNumber ?? "")
            coordinatesList = getValidCoordinates()
            print("coordinatesList: \(coordinatesList)")
        }
        // TODO: 실제로 줄어드는지 테스트 필요
        .onChange(of: busStopSearchViewModel.remainingStops) { searchResults in
            passedStops = busStopSearchViewModel.journeyStops.count - busStopSearchViewModel.remainingStops
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
                    .tint(.gray)
                Image(systemName: "location.fill")
                    .tint(.yellow)
            }
        }
    }
    
    /// 좌표의 옵셔널을 제거합니다.
    private func getValidCoordinates() -> [Coordinate] {
        busStopSearchViewModel.filteredBusStops.compactMap { stop in
            guard let latitude = stop.latitude,
                  let longitude = stop.longitude else {
                return nil
            }
            return Coordinate(latitude: latitude, longtitude: longitude)
        }
    }
}
