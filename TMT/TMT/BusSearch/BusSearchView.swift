//
//  BusSearchView.swift
//  TMT
//
//  Created by 김유빈 on 10/15/24.
//

import SwiftUI

struct BusSearchView: View {
    @StateObject private var busStopSearchViewModel: BusSearchViewModel
    @StateObject private var activityManager: LiveActivityManager
    @StateObject var locationManager: LocationManager
    
    @State private var selectedStartStop: BusStopInfo?
    @State private var selectedEndStop: BusStopInfo?
    
    @State private var tag: Int? = nil
    
    init() {
        let viewModel = BusSearchViewModel()
        let liveActivity = LiveActivityManager()
        _busStopSearchViewModel = StateObject(wrappedValue: viewModel)
        _activityManager = StateObject(wrappedValue: liveActivity)
        _locationManager = StateObject(wrappedValue: LocationManager(viewModel: viewModel, activityManager: liveActivity))
    }
    
    var body: some View {
        NavigationStack {
            NavigationLink(destination: BusStopView(locationManager: locationManager, busStopSearchViewModel: busStopSearchViewModel, endStop: selectedEndStop?.stopNameKorean ?? ""), tag: 1, selection: self.$tag) {
                EmptyView()
            }
            Button {
                self.tag = 1
                busStopSearchViewModel.searchBusStops(by: "207(기본)")
            } label: {
                Text("207번 버스")
                    .background(.white)
            }
        }
        .environmentObject(locationManager)
        .environmentObject(busStopSearchViewModel)
    }
}

#Preview {
    BusSearchView()
}
