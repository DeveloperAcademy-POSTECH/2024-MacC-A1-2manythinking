//
//  MapView.swift
//  TMT
//
//  Created by Choi Minkyeong on 10/15/24.
//

import SwiftUI

struct Coordinate: Identifiable {
    var id = UUID()
    var xCoordinate: Double
    var yCoordinate: Double
}

struct MapView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var busStopSearchViewModel: BusStopSearchViewModel
    
    @State private var items: [Coordinate] = []
    
    var body: some View {
        ZStack {
            mapViewWrapper
                .edgesIgnoringSafeArea(.all)
            controlsView
        }
        .onAppear {
            if locationManager.isFirstLoad {
                locationManager.findCurrentLocation()
            }
            items = getValidCoordinates()
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
    }
    
    private var mapViewWrapper: some View {
        MapViewWrapper(region: $locationManager.region, items: items)
    }
    
    private var controlsView: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button {
                    locationManager.findCurrentLocation()
                } label: {
                    ZStack {
                        Circle()
                            .frame(width: 44)
                            .tint(.gray)
                        Image(systemName: "location.fill")
                            .font(.title)
                            .tint(.purple)
                    }
                }
                Spacer().frame(width: 19)
            }
            Spacer().frame(height: 23)
            NextStopInfoView()
        }
        .padding()
    }
    
    private var backButton: some View {
        Button {
            self.presentationMode.wrappedValue.dismiss()
        } label: {
            ZStack {
                Circle()
                    .foregroundStyle(.black)
                    .frame(width: 50, height: 50)
                Image(systemName: "arrow.left")
                    .foregroundStyle(.white)
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
