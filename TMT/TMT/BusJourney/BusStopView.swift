//
//  MapView.swift
//  TMT
//
//  Created by Choi Minkyeong on 10/15/24.
//

import SwiftUI

// TODO: 현재 위치 점 노랑색으로 커스텀하기
struct Coordinate: Identifiable {
    var id = UUID()
    var xCoordinate: Double
    var yCoordinate: Double
}

struct BusStopView: View {
    @ObservedObject var locationManager: LocationManager
    @ObservedObject var busStopSearchViewModel: BusStopSearchViewModel
    @State private var items: [Coordinate] = []
    @State private var journeyStops: [BusStopInfo] = []
    
    var endStop: String
    
    var body: some View {
        ZStack {
            mapViewWrapper
                .edgesIgnoringSafeArea(.vertical)
            VStack {
                ThisStopView(stopNameKorean: journeyStops.first?.stopNameKorean ?? "", stopNameNaver: journeyStops.first?.stopNameNaver ?? "", stopNameRomanized: journeyStops.first?.stopNameRomanized ?? "")
                HStack {
                    Spacer()
                    controlsView
                    // TODO: 여기 왜 기본으로 spacer() 쓰면 밖에 나가버리는지 이유 찾기.
                        .padding(.trailing, 26.6)
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
            items = getValidCoordinates()
        }
    }
    
    private var mapViewWrapper: some View {
        MapViewWrapper(region: $locationManager.region, items: items)
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
            return Coordinate(xCoordinate: latitude, yCoordinate: longitude)
        }
    }
}
