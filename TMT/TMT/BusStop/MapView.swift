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
    @ObservedObject var busStopSearchViewModel: BusStopSearchViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $locationManager.region, showsUserLocation: true, annotationItems: busStopSearchViewModel.filteredBusStops) { stop in
                MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: Double(stop.xCoordinate ?? "") ?? 0, longitude: Double(stop.yCoordinate ?? "") ?? 0)) {
                    VStack {
                        RoundedRectangle(cornerRadius: 5)
                            .frame(width: 40, height: 40)
                            .foregroundStyle(.black)
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
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
                NextStopView()
            }
            .padding()
        }
        .onAppear {
            locationManager.findCurrentLocation()
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
    }
    
    var backButton : some View {
        Button{
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
}

