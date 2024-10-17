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
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $locationManager.region, showsUserLocation: true)
                .edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
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
                Spacer()
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
