//
//  ScannedJourneyInfoView.swift
//  TMT
//
//  Created by Choi Minkyeong on 11/3/24.
//

import SwiftUI
import PhotosUI

struct ScannedJourneyInfoView: View {
    @State private var busNumber: String = ""
    @State private var startStop: String = ""
    @State private var endStop: String = ""
    @State private var pickedItem: PhotosPickerItem? = nil
    @Binding var scannedJourneyInfo: String
    @Binding var selectedImage: UIImage?
    @Binding var isLoading: Bool
    
    @StateObject private var searchModel: BusSearchViewModel
    @StateObject private var journeyModel: JourneySettingViewModel
    @StateObject private var activityManager: LiveActivityManager
    @StateObject var locationManager: LocationManager
    
    @State private var selectedStartStop: BusStop?
    @State private var selectedEndStop: BusStop?
    
    @State private var tag: Int? = nil
    
    init(scannedJourneyInfo: Binding<String>, selectedImage: Binding<UIImage?>, isLoading: Binding<Bool>) {
        let searchModel = BusSearchViewModel()
        let journeyModel = JourneySettingViewModel(searchModel: searchModel)
        let activityManager = LiveActivityManager()
        _searchModel = StateObject(wrappedValue: searchModel)
        _journeyModel = StateObject(wrappedValue: journeyModel)
        _activityManager = StateObject(wrappedValue: activityManager)
        _locationManager = StateObject(wrappedValue: LocationManager(activityManager: activityManager, journeyModel: journeyModel))
        _scannedJourneyInfo = scannedJourneyInfo
        _selectedImage = selectedImage
        _isLoading = isLoading
    }
    
    private let ocrService = OCRService()
    
    var body: some View {
        VStack(alignment: .leading) {
            uploadedInfoBox(title: "Bus Number", scannedInfo: $busNumber)
            uploadedInfoBox(title: "Departure Stop", scannedInfo: $startStop)
            uploadedInfoBox(title: "Arrival Stop", scannedInfo: $endStop)
            
            HStack(spacing: 0) {
                PhotosPicker(selection: $pickedItem, matching: .screenshots) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.Brand.primary, lineWidth: 1)
                        
                        Text("Reupload")
                            .foregroundStyle(Color.Brand.primary)
                    }
                    .padding(.trailing, 8)
                }
                .onChange(of: pickedItem) {
                    Task {
                        scannedJourneyInfo = ""
                        if let data = try? await pickedItem?.loadTransferable(type: Data.self),
                           let image = UIImage(data: data) {
                            selectedImage = image
                            ocrService.startOCR(image: image) { info in
                                isLoading = false
                                if !info.isEmpty {
                                    scannedJourneyInfo = info
                                }
                            }
                        }
                    }
                }
                NavigationLink(destination: BusStopView()
                    .environmentObject(locationManager)
                    .environmentObject(searchModel)
                    .environmentObject(activityManager)
                    .environmentObject(journeyModel), tag: 1, selection: self.$tag) {
                        EmptyView()
                    }
                
                Button {
                    journeyModel.setJourneyStops(busNumberString: busNumber, startStopString: startStop, endStopString: endStop)
                    
                    guard let endStop = journeyModel.journeyStops.last else { return }
                    activityManager.startLiveActivity(destinationInfo: endStop, remainingStops: locationManager.remainingStops)
                    
                    if journeyModel.journeyStops.isEmpty {
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
            }
            .frame(height: 52)
            .padding(.vertical, 12.5)
        }
        .onAppear {
            splitScannedInfo()
        }
    }
    
    private func splitScannedInfo() {
        let splitted = scannedJourneyInfo.split(separator: ",")
        if splitted.count >= 3 {
            busNumber = String(splitted[1])
            startStop = String(splitted[0])
            endStop = String(splitted[2])
        }
        if let lastChar = busNumber.last, lastChar == " " {
            busNumber = String(busNumber.dropLast())
        }
        if let lastChar = startStop.last, lastChar == " " {
            startStop = String(startStop.dropLast())
        }
        if let lastChar = endStop.last, lastChar == " " {
            endStop = String(endStop.dropLast())
        }
    }
    
    private func uploadedInfoBox(title: String, scannedInfo: Binding<String>) -> some View {
        VStack(alignment: .leading) {
            Text("\(title)")
                .foregroundStyle(Color.Basic.grey300)
            TextField("\(scannedInfo.wrappedValue)", text: scannedInfo)
                .bold()
                .font(.title)
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .center)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(Color.Basic.grey100, lineWidth: 1)
                        .background(Color.white.cornerRadius(8))
                )
                .keyboardType(title == "Bus Number" ? .numberPad : .default)
        }
        .padding(.bottom, 16)
    }
}

