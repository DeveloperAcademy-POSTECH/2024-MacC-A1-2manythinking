//
//  ScannedJourneyInfoView.swift
//  TMT
//
//  Created by Choi Minkyeong on 11/3/24.
//

import SwiftUI
import PhotosUI

struct ScannedJourneyInfoView: View {
//    @State private var busNumber: String = ""
//    @State private var startStop: String = ""
//    @State private var endStop: String = ""
    @State private var pickedItem: PhotosPickerItem? = nil
    @Binding var scannedJourneyInfo: (busNumber: String, startStop: String, endStop: String)
    @Binding var selectedImage: UIImage?
    @State var isLoading: Bool = false
    
    @StateObject private var searchModel: BusSearchModel
    @StateObject private var journeyModel: JourneySettingModel
    @StateObject private var activityManager: LiveActivityManager
    @StateObject var locationManager: LocationManager
    
    @State private var tag: Int? = nil
    @State private var showingAlert: Bool = false
    @State private var showingPhotosPicker: Bool = false
    @State private var hasError: Bool = false
    @State private var isShowingOnboarding = false
    
    init(scannedJourneyInfo: Binding<(busNumber: String, startStop: String, endStop: String)>, selectedImage: Binding<UIImage?>) {
        let searchModel = BusSearchModel()
        let journeyModel = JourneySettingModel(searchModel: searchModel)
        let activityManager = LiveActivityManager()
        _searchModel = StateObject(wrappedValue: searchModel)
        _journeyModel = StateObject(wrappedValue: journeyModel)
        _activityManager = StateObject(wrappedValue: activityManager)
        _locationManager = StateObject(wrappedValue: LocationManager(activityManager: activityManager, journeyModel: journeyModel))
        _scannedJourneyInfo = scannedJourneyInfo
        _selectedImage = selectedImage
    }
    
    private let ocrStarter = OCRStarterManager()
    
    var body: some View {
        ScrollView {
            ZStack {
                Color.white
                    .ignoresSafeArea()
                VStack {
                    UploadedPhotoView(selectedImage: $selectedImage)
                        .padding(.horizontal, 16)
                    
                    VStack(alignment: .leading) {
                        uploadedInfoBox(title: "Bus Number", scannedInfo: $scannedJourneyInfo.busNumber)
                        uploadedInfoBox(title: "Departure Stop", scannedInfo: $scannedJourneyInfo.startStop)
                        uploadedInfoBox(title: "Arrival Stop", scannedInfo: $scannedJourneyInfo.endStop)
                        
                        if hasError {
                            HStack {
                                VStack {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                    Spacer()
                                }
                                Text("As the information was entered incorrectly, please reupload the screenshot.")
                            }
                            .foregroundStyle(Color.Basic.red600)
                        }
                        
                        HStack(spacing: 0) {
                            Button {
                                showingAlert = true
                            } label: {
                                ZStack {
                                    if !hasError {
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.Brand.primary, lineWidth: 1)
                                        Text("Reupload")
                                            .foregroundStyle(Color.Brand.primary)
                                    } else {
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.Basic.grey900)
                                            .stroke(Color.Basic.grey900)
                                        Text("Reupload")
                                            .foregroundStyle(.white)
                                    }
                                }
                            }
                            .padding(.trailing, 8)
                            .alert("Information will disappear.", isPresented: $showingAlert) {
                                Button {
                                    showingAlert = false
                                } label: {
                                    Text("Cancel")
                                        .foregroundStyle(.blue)
                                }
                                
                                Button {
                                    showingAlert = false
                                    showingPhotosPicker = true
                                } label: {
                                    Text("Confirm")
                                        .foregroundStyle(.blue)
                                        .fontWeight(.bold)
                                }
                            } message: {
                                Text("The previously uploaded image information will disappear. Do you want to proceed?")
                            }
                            
                            PhotosPicker(selection: $pickedItem, matching: .screenshots) {
                                EmptyView()
                            }
                            .onChange(of: pickedItem) {
                                loadImage(from: pickedItem)
                            }
                            .photosPicker(isPresented: $showingPhotosPicker, selection: $pickedItem, matching: .screenshots)
                            
                            NavigationLink(destination: BusStopView()
                                .environmentObject(locationManager)
                                .environmentObject(searchModel)
                                .environmentObject(activityManager)
                                .environmentObject(journeyModel), tag: 1, selection: self.$tag) {
                                    EmptyView()
                                }
                            
                            Button {
                                journeyModel.setJourneyStops(busNumberString: scannedJourneyInfo.busNumber, startStopString: scannedJourneyInfo.startStop, endStopString: scannedJourneyInfo.endStop)
                                
                                guard let endStop = journeyModel.journeyStops.last else { return }
                                activityManager.startLiveActivity(destinationInfo: endStop, remainingStops: locationManager.remainingStops)
                                self.tag = 1
                            } label: {
                                ZStack {
                                    if !hasError {
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.Brand.primary)
                                            .stroke(Color.Brand.primary)
                                        Text("Start")
                                            .foregroundStyle(.black)
                                    } else {
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.Basic.grey100)
                                            .stroke(Color.Basic.grey100)
                                        Text("Start")
                                            .foregroundStyle(.white)
                                    }
                                }
                            }
                            .disabled(hasError)
                        }
                        .frame(height: 52)
                        .padding(.vertical, 12.5)
                    }
                    .padding(.horizontal, 16)
                }
                if isShowingOnboarding {
                    OnboardingView(isShowingOnboarding: $isShowingOnboarding)
                        .onDisappear {
                            isShowingOnboarding = false
                        }
                }
            }
            .navigationBarBackButtonHidden()
            .toolbar {
                Button {
                    isShowingOnboarding = true
                } label: {
                    Label("Info", systemImage: "info.circle")
                        .font(.title2)
                }
            }
//            .onAppear {
//                let journeyInfo = ocrStarter.splitScannedInfo(scannedJourneyInfo: scannedJourneyInfo)
//                busNumber = journeyInfo.busNumber
//                startStop = journeyInfo.startStop
//                endStop = journeyInfo.endStop
//            }
        }
    }
    
    func loadImage(from item: PhotosPickerItem?) {
        Task {
//            var scannedJourneyInfo: String = ""
            
            guard let item = item else { return }
            if let data = try? await item.loadTransferable(type: Data.self),
               let image = UIImage(data: data) {
                selectedImage = image
                isLoading = true
                hasError = false
//                scannedJourneyInfo = ""
                
                
                ocrStarter.startOCR(image: image) { info in
                    isLoading = false
                    if info.busNumber.isEmpty && info.startStop.isEmpty && info.endStop.isEmpty {
                        hasError = true
                    } else {
                        scannedJourneyInfo = ocrStarter.splitScannedInfo(scannedJourneyInfo: info)
                    }
                }
            }
        }
    }
    
    private func uploadedInfoBox(title: String, scannedInfo: Binding<String>) -> some View {
        VStack(alignment: .leading) {
            Text("\(title)")
                .foregroundStyle(.grey300)
            TextField("\(scannedInfo.wrappedValue)", text: scannedInfo)
                .bold()
                .font(.title)
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .center)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(.grey100, lineWidth: 1)
                        .background(Color.basicWhite.cornerRadius(8))
                )
                .keyboardType(title == "Bus Number" ? .numberPad : .default)
        }
        .padding(.bottom, 16)
    }
}

