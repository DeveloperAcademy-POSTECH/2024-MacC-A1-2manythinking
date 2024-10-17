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
    var body: some View {
        ZStack {
            Map(coordinateRegion: $locationManager.region, showsUserLocation: true, annotationItems: busStopSearchViewModel.nameAndCoordinates) { stop in
                MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: Double(stop.latitude) ?? 0, longitude: Double(stop.longitude) ?? 0)) {
                    VStack {
                        RoundedRectangle(cornerRadius: 5)
                            .frame(width: 30, height: 30)
                            .foregroundStyle(.blue)
                        Text(stop.name)
                            .font(.caption)
                            .foregroundColor(.black)
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
