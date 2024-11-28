//
//  NotUploadedView.swift
//  TMT
//
//  Created by Choi Minkyeong on 11/4/24.
//

import SwiftUI
import PhotosUI

struct NotUploadedView: View {
    @EnvironmentObject var imageHandler: ImageHandlerModel
    @State private var pickedItem: PhotosPickerItem? = nil
    @State private var showingAlert = false
    @State private var tag: Int? = nil
    @Binding var path: [String]
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("Ride Confident,\nArrive Intentionally")
                        .font(.title)
                        .bold()
                    Spacer()
                }
                HStack(spacing: 0) {
                    Text("Whether you don't know Korean,\nyou can know\nwhere to get off the bus.")
                        .padding(.bottom, 10)
                        .foregroundStyle(.brandPrimary)
                                                .font(.title3.weight(.bold))
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
                
                NavigationLink(destination: ScannedJourneyInfoView(scannedJourneyInfo: $imageHandler.scannedJourneyInfo, path: $path).environmentObject(imageHandler), tag: 1, selection: $tag) {
                    EmptyView()
                }
                
                PhotosPicker(
                    selection: $pickedItem,
                    matching: .screenshots
                ) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .inset(by: 1)
                            .stroke(.yellow, style: StrokeStyle(lineWidth: 2, dash: [4, 4]))
                            .aspectRatio(1.0, contentMode: .fit)
                        HStack(alignment: .center, spacing: 8) {
                            Image(systemName: "photo")
                            Text("Upload Path Screenshot")
                        }
                        .foregroundStyle(.yellow600)
                    }
                }
                .onChange(of: pickedItem) {
                    imageHandler.loadImage(from: pickedItem, viewCategory: "NotUploadedView") {
                        if !imageHandler.showAlertScreen {
                            tag = 1
                            path.append("ScannedJourneyInfo")
                        }
                        pickedItem = nil
                    }
                }
                .alert("Failed to recognize the image.", isPresented: $imageHandler.showAlertScreen) {
                    Button {
                        imageHandler.showAlertScreen = false
                    } label: {
                        Text("Reupload")
                            .foregroundStyle(.blue)
                    }
                } message: {
                    Text("Image recognition failed during upload. Please upload the image again.")
                }
            }
            
            if imageHandler.isLoading {
                ProgressView()
            }
        }
    }
}
