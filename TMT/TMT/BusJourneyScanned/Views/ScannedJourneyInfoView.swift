//
//  ScannedJourneyInfoView.swift
//  TMT
//
//  Created by Choi Minkyeong on 11/3/24.
//

import SwiftUI
import PhotosUI

struct ScannedJourneyInfoView: View {
    @EnvironmentObject var imageHandler: ImageHandlerModel
    @StateObject private var searchModel: BusSearchModel
    @StateObject private var journeyModel: JourneySettingModel
    @StateObject private var activityManager: LiveActivityManager
    @StateObject var locationManager: LocationManager
    
    @State private var tag: Int? = nil
    @State private var showingAlert: Bool = false
    @State private var showingPhotosPicker: Bool = false
    @State private var isShowingOnboarding = false
    @State private var pickedItem: PhotosPickerItem? = nil
    @Binding var path: [String]
    
    init(scannedJourneyInfo: Binding<ScannedJourneyInfo>, path: Binding<[String]>) {
        let searchModel = BusSearchModel()
        let journeyModel = JourneySettingModel(searchModel: searchModel)
        let activityManager = LiveActivityManager()
        
        _searchModel = StateObject(wrappedValue: searchModel)
        _journeyModel = StateObject(wrappedValue: journeyModel)
        _activityManager = StateObject(wrappedValue: activityManager)
        _locationManager = StateObject(wrappedValue: LocationManager(activityManager: activityManager, journeyModel: journeyModel))
        _path = path
    }
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            ScrollView {
                VStack {
                    if !imageHandler.showAlertScreen {
                        UploadedPhotoView(selectedImage: $imageHandler.selectedImage)
                            .padding(.horizontal, 16)
                    } else {
                        UploadedPhotoView(selectedImage: .constant(nil))
                            .padding(.horizontal, 16)
                    }
                    
                    VStack(alignment: .leading) {
                        uploadedInfoBox(title: "Bus Number", scannedInfo: $imageHandler.scannedJourneyInfo.busNumber)
                        uploadedInfoBox(title: "Departure Stop", scannedInfo: $imageHandler.scannedJourneyInfo.startStop)
                        uploadedInfoBox(title: "Arrival Stop", scannedInfo: $imageHandler.scannedJourneyInfo.endStop)
                        
                        if imageHandler.showAlertText {
                            HStack {
                                VStack {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                    Spacer()
                                }
                                Text("As the information was entered incorrectly, please reupload the screenshot.")
                            }
                            .foregroundStyle(.red600)
                        }
                        
                        HStack(spacing: 0) {
                            Button {
                                showingAlert = true
                            } label: {
                                ZStack {
                                    if !imageHandler.showAlertText {
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.Brand.primary, lineWidth: 1)
                                        Text("Reupload")
                                            .foregroundStyle(.brandPrimary)
                                    } else {
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(.grey900)
                                            .stroke(.grey900)
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
                                    imageHandler.scannedJourneyInfo = ScannedJourneyInfo(busNumber: "", startStop: "", endStop: "")
                                    imageHandler.selectedImage = nil
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
                                imageHandler.loadImage(from: pickedItem, viewCategory: "ScannedJourneyInfoView", completion: {})
                            }
                            .photosPicker(isPresented: $showingPhotosPicker, selection: $pickedItem, matching: .screenshots)
                            
                            NavigationLink(destination: BusStopView(path: $path)
                                .environmentObject(locationManager)
                                .environmentObject(searchModel)
                                .environmentObject(activityManager)
                                .environmentObject(journeyModel)
                                .environmentObject(imageHandler), tag: 1, selection: $tag) {
                                    EmptyView()
                                }
                            
                            PrimaryButton(title: "Start", color: imageHandler.showAlertText ? .grey100 : .brandPrimary) {
                                if !imageHandler.showAlertText {
                                    journeyModel.setJourneyStops(
                                        busNumberString: imageHandler.scannedJourneyInfo.busNumber,
                                        startStopString: imageHandler.scannedJourneyInfo.startStop,
                                        endStopString: imageHandler.scannedJourneyInfo.endStop
                                    )
                                    
                                    guard let endStop = journeyModel.journeyStops.last else { return }
                                    activityManager.startLiveActivity(
                                        destinationInfo: endStop,
                                        remainingStops: locationManager.remainingStops
                                    )
                                    tag = 1
                                    path.append("BusStop")
                                }
                            }
                            .disabled(imageHandler.showAlertText)
                        }
                        .frame(height: 52)
                        .padding(.vertical, 12.5)
                    }
                    .padding(.horizontal, 16)
                }
            }
            
            if isShowingOnboarding {
                OnboardingModalView(isShowingOnboarding: $isShowingOnboarding)
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
                Image(systemName: "info.circle")
                    .foregroundStyle(.grey600)
            }
            .disabled(isShowingOnboarding)
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

