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
    @StateObject private var locationManager = LocationManager()
    @ObservedObject var busStopSearchViewModel: BusStopSearchViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
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
            items = getCoordinates()
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
    private func getCoordinates() -> [Coordinate] {
        busStopSearchViewModel.filteredBusStops.compactMap { stop in
            guard let xCoordinate = stop.xCoordinate,
                  let yCoordinate = stop.yCoordinate,
                  let x = Double(xCoordinate),
                  let y = Double(yCoordinate) else {
                return nil
            }
            return Coordinate(xCoordinate: x, yCoordinate: y)
        }
    }
}
