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
    @ObservedObject var locationManager: LocationManager
    @ObservedObject var busStopSearchViewModel: BusStopSearchViewModel
    @State private var coordinatesList: [Coordinate] = []
    @State private var journeyStops: [BusStopInfo] = []
    
    var endStop: String
    
    var body: some View {
        ZStack {
            busStopViewWrapper
                .edgesIgnoringSafeArea(.vertical)
            VStack {
                ThisStopView(stopNameKorean: journeyStops.first?.stopNameKorean ?? "", stopNameNaver: journeyStops.first?.stopNameNaver ?? "", stopNameRomanized: journeyStops.first?.stopNameRomanized ?? "")
                HStack {
                    Spacer()
                    controlsView
                        .padding(.trailing, 15.48)
                        .padding(.top, 23.91)
                }
                Spacer()
                EndStopView(endStop: endStop, remainingStops: busStopSearchViewModel.remainingStops)
            }
        }
        // TODO: 테스트 필요
        .onChange(of: busStopSearchViewModel.remainingStops) { searchResults in
            journeyStops = busStopSearchViewModel.journeyStops
        }
        .onAppear {
            if locationManager.isFirstLoad {
                locationManager.findCurrentLocation()
            }
            coordinatesList = getValidCoordinates()
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
