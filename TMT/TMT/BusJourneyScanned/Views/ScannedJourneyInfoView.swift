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
    @State private var isShowingInformation = false
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
            Color.brandBackground
                .ignoresSafeArea()
            VStack {
                ScrollView {
                    if !imageHandler.showAlertScreen {
                        UploadedPhotoView(selectedImage: $imageHandler.selectedImage)
                    } else {
                        UploadedPhotoView(selectedImage: .constant(nil))
                    }
                    
                    VStack(alignment: .leading) {
                        uploadedInfoBox(title: "Bus Number", scannedInfo: $imageHandler.scannedJourneyInfo.busNumber)
                        uploadedInfoBox(title: "Departure Stop", scannedInfo: $imageHandler.scannedJourneyInfo.startStop)
                        uploadedInfoBox(title: "Arrival Stop", scannedInfo: $imageHandler.scannedJourneyInfo.endStop)
                    }
                }
                
                if imageHandler.showAlertText {
                    HStack {
                        VStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                            Spacer()
                        }
                        Text("As the information was entered incorrectly, please reupload the screenshot.")
                            .font(.system(size: 16, weight: .medium))
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .onAppear {
                        imageHandler.scannedJourneyInfo = ScannedJourneyInfo(busNumber: "", startStop: "", endStop: "")
                    }
                    .frame(height: 42)
                    .foregroundStyle(.red600)
                }
                
                HStack(spacing: 0) {
                    Group {
                        if imageHandler.showAlertText {
                            FilledButton(title: "Reupload", fillColor: .basicBlack, textColor: .basicWhite) {
                                showingAlert = true
                            }
                        } else {
                            OutlinedButton(
                                title: "Reupload",
                                strokeColor: .brandPrimary,
                                textColor: .brandPrimary
                            ) {
                                showingAlert = true
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
                            // TODO: 커스텀 안되는 문제 해결하기 (bold 처리가 안됨)
                            Text("Confirm")
                                .foregroundStyle(.blue)
                                .font(.footnote.weight(.bold))
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
                    
                    NavigationLink(destination: MapView(path: $path)
                        .environmentObject(locationManager)
                        .environmentObject(searchModel)
                        .environmentObject(activityManager)
                        .environmentObject(journeyModel)
                        .environmentObject(imageHandler), tag: 1, selection: $tag) {
                            EmptyView()
                        }
                    
                    FilledButton(
                        title: "Start",
                        fillColor: imageHandler.showAlertText ? .grey100 : .brandPrimary
                    ) {
                        if !imageHandler.showAlertText {
                            journeyModel.setJourneyStops(
                                busNumberString: imageHandler.scannedJourneyInfo.busNumber,
                                startStopString: imageHandler.scannedJourneyInfo.startStop,
                                endStopString: imageHandler.scannedJourneyInfo.endStop
                            )
                            
                            guard let startStop = journeyModel.journeyStops.first else { return }
                            guard let endStop = journeyModel.journeyStops.last else { return }
                            
                            activityManager.startLiveActivity(startBusStop: startStop, endBusStop: endStop, remainingStops: locationManager.remainingStops)
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
            
            if isShowingInformation {
                InformationModalView(isShowingInformation: $isShowingInformation)
                    .onDisappear {
                        isShowingInformation = false
                    }
            }
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            Button {
                isShowingInformation = true
            } label: {
                Image(systemName: "info.circle")
                    .foregroundStyle(.grey600)
                    .font(.system(size: 17, weight: .regular))
            }
            .disabled(isShowingInformation)
        }
        
    }
    
    private func uploadedInfoBox(title: String, scannedInfo: Binding<String>) -> some View {
        VStack(alignment: .leading) {
            Text("\(title)")
                .foregroundStyle(.grey300)
                .font(.system(size: 14, weight: .medium))
            
            TextField("\(scannedInfo.wrappedValue)", text: scannedInfo)
                .foregroundStyle(.textDefault)
                .font(.system(size: 20, weight: .bold))
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .center)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(.grey100, lineWidth: 1)
                        .background(Color.brandBackground.cornerRadius(8))
                )
                .keyboardType(title == "Bus Number" ? .numberPad : .default)
        }
        .padding(.bottom, 16)
    }
}

#Preview {
    ScannedJourneyInfoView(scannedJourneyInfo: .constant(ScannedJourneyInfo(busNumber: "207", startStop: "1", endStop: "2")), path: .constant(["ScannedJourneyInfoView"]))
}
