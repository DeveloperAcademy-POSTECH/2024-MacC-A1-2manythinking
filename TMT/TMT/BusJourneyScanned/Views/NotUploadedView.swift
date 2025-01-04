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
            VStack(spacing: 0) {
                HStack {
                    Text("Don’t worry\nRide comfortably")
                        .title1Bold()
                        .font(.system(size: 28, weight: .bold))

                    Spacer()
                }
                .padding(.bottom, 10)
                
                HStack(spacing: 0) {
                    Text("We will let you know\nthe exact location to get off.")
                        .title4()
                        .padding(.bottom, 10)
                        .foregroundStyle(.brandPrimary)
                        .multilineTextAlignment(.leading)

                    Spacer()
                }
                
                NavigationLink(destination: ScannedJourneyInfoView(path: $path), tag: 1, selection: $tag) {
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
                            
                            Text("Upload Screenshot")
                                .body1()
                        }
                        .foregroundStyle(.yellow600)
                    }
                }
                .onChange(of: pickedItem) {
                    imageHandler.loadImageByPhotosPickerItem(from: pickedItem, viewCategory: "NotUploadedView") {
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
                        Text("Okay")
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
        .onAppear {
            if let sharedDefaults = UserDefaults(suiteName: "group.twomanythinking.TMT"),
               sharedDefaults.bool(forKey: "isShared"),
               let imageData = sharedDefaults.data(forKey: "sharedImage"),
               let image = UIImage(data: imageData) {
                imageHandler.loadImagebyUIImage(from: image, viewCategory: "NotUploadedView") {
                    if !imageHandler.showAlertScreen {
                        tag = 1
                        path.append("ScannedJourneyInfo")
                    }
                    
                    sharedDefaults.set(false, forKey: "isShared")
                    sharedDefaults.synchronize()
                }
            }
        }
    }
}
