//
//  BusStopSearchTest.swift
//  TMT
//
//  Created by Choi Minkyeong on 11/8/24.
//

import SwiftUI
import PhotosUI

struct BusStopSearchTest: View {
    @State private var busNumber: String = ""
    @State private var startStop: String = ""
    @State private var endStop: String = ""
    @State private var pickedItem: PhotosPickerItem? = nil
    @Binding var scannedJourneyInfo: String
    
    @StateObject private var busStopSearchViewModel: BusSearchViewModel
    @StateObject private var liveActivityManager: LiveActivityManager
    @StateObject var locationManager: LocationManager
    
    @State private var selectedStartStop: BusStopInfo?
    @State private var selectedEndStop: BusStopInfo?
    
    @State private var tag: Int? = nil
    
    private let ocrService = OCRService()
    
    init(scannedJourneyInfo: Binding<String>) {
        let viewModel = BusSearchViewModel()
        let liveActivity = LiveActivityManager()
        _busStopSearchViewModel = StateObject(wrappedValue: viewModel)
        _liveActivityManager = StateObject(wrappedValue: liveActivity)
        _locationManager = StateObject(wrappedValue: LocationManager(viewModel: viewModel, activityManager: liveActivity))
        _scannedJourneyInfo = scannedJourneyInfo
    }
    
    var body: some View {
        VStack(alignment: .leading) {
                NavigationLink(destination: BusStopView().environmentObject(locationManager)
                    .environmentObject(busStopSearchViewModel), tag: 1, selection: self.$tag) {
                        EmptyView()
                    }
                
                Button {
                    busStopSearchViewModel.setJourneyStops(startStopString: startStop, endStopString: endStop)
                    
                    guard let endStop = busStopSearchViewModel.journeyStops.last else { return }
                    if busStopSearchViewModel.journeyStops.count == 0 {
                        // TODO: 버스 루트를 못찾은 경우 에러처리하기
                    } else {
                        self.tag = 1
                    }
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.Brand.primary)
                            .stroke(Color.Brand.primary)
                        Text("Start")
                            .foregroundStyle(.black)
                    }
                }
            .frame(height: 52)
            .padding(.vertical, 12.5)
        }
        .onAppear {
            busNumber = "207"
        }
        .environmentObject(locationManager)
        .environmentObject(busStopSearchViewModel)
    }
}

