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
                    Text("Put your worries away\nAnd take the bus\ncomfortably")
                        .foregroundStyle(.textDefault)
                        .font(.system(size: 28, weight: .bold))
                        .bold()
                    Spacer()
                }
                .padding(.bottom, 10)
                
                HStack(spacing: 0) {
                    Text("We will let you know exact location to\nget off")
                        .padding(.bottom, 10)
                        .foregroundStyle(.brandPrimary)
                        .font(.system(size: 20, weight: .bold))
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
                .padding(.bottom, 24)
                
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
                            Text("Upload Screenshot")
                                .font(.system(size: 18, weight: .medium))
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
