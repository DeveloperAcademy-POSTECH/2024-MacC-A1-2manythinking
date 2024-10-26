//
//  MapView.swift
//  TMT
//
//  Created by Choi Minkyeong on 10/15/24.
//

import SwiftUI
import MapKit

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
            mapView
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
    
    private var mapView: some View {
        Map(coordinateRegion: $locationManager.region, showsUserLocation: true, annotationItems: items) { stop in
            MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: stop.xCoordinate, longitude: stop.yCoordinate)) {
                RoundedRectangle(cornerRadius: 5)
                    .frame(width: 40, height: 40)
                    .foregroundStyle(.black)
            }
        }
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
    
    /// BusStopInfo를 Coordinate로 변환하는 함수
    private func getCoordinates() -> [Coordinate] {
        busStopSearchViewModel.filteredBusStops.compactMap { stop in
            guard let xCoordinate = stop.xCoordinate,
                  let yCoordinate = stop.yCoordinate else {
                return nil
            }
            return Coordinate(xCoordinate: xCoordinate, yCoordinate: yCoordinate)
        }
    }
}
