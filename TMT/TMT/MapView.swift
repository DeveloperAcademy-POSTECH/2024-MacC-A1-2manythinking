//
//  MapView.swift
//  TMT
//
//  Created by Choi Minkyeong on 10/15/24.
//

import SwiftUI
import MapKit

struct MapView: View {
    @StateObject private var locationManager = LocationManager()
    @StateObject var busStopSearchViewModel = BusStopSearchViewModel()
    
    // TODO: 사용자 위치 바뀌어도 화면 다시 업데이트 안되게 하기.
    // 투두: 다시 테스트 해보고, 밑에 스트링 값 없을 때 대신 넣는거 생각해보기.
    var body: some View {
        ZStack {
            Map(coordinateRegion: $locationManager.region, showsUserLocation: true, annotationItems: busStopSearchViewModel.nameAndCoordinates) { stop in
                MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: Double(stop.xCoordinate ?? "") ?? 0, longitude: Double(stop.yCoordinate ?? "") ?? 0)) {
                    VStack {
                        RoundedRectangle(cornerRadius: 5)
                            .frame(width: 30, height: 30)
                            .foregroundStyle(.blue)
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
            VStack {
                Button {
                    busStopSearchViewModel.getNameAndCoordinates(busNum: "207(기본)")
                } label: {
                    Text("207번 버스")
                        .background(.white)
                }
                
                Button {
                    busStopSearchViewModel.getNameAndCoordinates(busNum: "306(기본)")
                } label: {
                    Text("472번 버스")
                        .background(.white)
                }
                
                Spacer()
                Button {
                    locationManager.findCurrentLocation()
                } label: {
                    ZStack {
                        Circle()
                            .frame(width: 40)
                            .tint(.white)
                            .shadow(radius: 5)
                        Image(systemName: "location.fill")
                            .font(.title)
                            .tint(.gray)
                    }
                }
                
            }
            .padding()
        }
        .onAppear {
            locationManager.findCurrentLocation()
        }
    }
}

#Preview {
    MapView()
}
