//
//  ScannedJourneyInfoView.swift
//  TMT
//
//  Created by Choi Minkyeong on 11/3/24.
//

import SwiftUI
import PhotosUI

struct ScannedJourneyInfoView: View {
    @EnvironmentObject var inputDisplayModel: InputDisplayModel
    @StateObject private var searchModel: BusSearchModel
    @StateObject private var journeyModel: JourneySettingModel
    @StateObject private var activityManager: LiveActivityManager
    @StateObject var locationManager: LocationManager
    
    @State private var tag: Int? = nil
    @State private var showingAlert: Bool = false
    @State private var showingPhotosPicker: Bool = false
    @State private var isShowingOnboarding = false
    @State private var pickedItem: PhotosPickerItem? = nil
    
    init(scannedJourneyInfo: Binding<ScannedJourneyInfo>) {
        let searchModel = BusSearchModel()
        let journeyModel = JourneySettingModel(searchModel: searchModel)
        let activityManager = LiveActivityManager()
        
        _searchModel = StateObject(wrappedValue: searchModel)
        _journeyModel = StateObject(wrappedValue: journeyModel)
        _activityManager = StateObject(wrappedValue: activityManager)
        _locationManager = StateObject(wrappedValue: LocationManager(activityManager: activityManager, journeyModel: journeyModel))
    }
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            ScrollView {
                VStack {
                    if !inputDisplayModel.showAlertScreen {
                        UploadedPhotoView(selectedImage: $inputDisplayModel.selectedImage)
                            .padding(.horizontal, 16)
                    } else {
                        UploadedPhotoView(selectedImage: .constant(nil))
                            .padding(.horizontal, 16)
                    }
                    
                    VStack(alignment: .leading) {
                        uploadedInfoBox(title: "Bus Number", scannedInfo: $inputDisplayModel.scannedJourneyInfo.busNumber)
                        uploadedInfoBox(title: "Departure Stop", scannedInfo: $inputDisplayModel.scannedJourneyInfo.startStop)
                        uploadedInfoBox(title: "Arrival Stop", scannedInfo: $inputDisplayModel.scannedJourneyInfo.endStop)
                        
                        if inputDisplayModel.showAlertText {
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
                                    if !inputDisplayModel.showAlertText {
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
                                    inputDisplayModel.scannedJourneyInfo = ScannedJourneyInfo(busNumber: "", startStop: "", endStop: "")
                                    inputDisplayModel.selectedImage = nil
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
                                inputDisplayModel.loadImage(from: pickedItem, viewCategory: "ScannedJourneyInfoView", completion: {})
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
                                journeyModel.setJourneyStops(busNumberString: inputDisplayModel.scannedJourneyInfo.busNumber, startStopString: inputDisplayModel.scannedJourneyInfo.startStop, endStopString: inputDisplayModel.scannedJourneyInfo.endStop)
                                
                                guard let endStop = journeyModel.journeyStops.last else { return }
                                activityManager.startLiveActivity(destinationInfo: endStop, remainingStops: locationManager.remainingStops)
                                self.tag = 1
                            } label: {
                                ZStack {
                                    if !inputDisplayModel.showAlertText {
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
                            .disabled(inputDisplayModel.showAlertText)
                        }
                        .frame(height: 52)
                        .padding(.vertical, 12.5)
                    }
                    .padding(.horizontal, 16)
                }
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

