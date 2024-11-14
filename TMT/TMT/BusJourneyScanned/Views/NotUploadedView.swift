//
//  NotUploadedView.swift
//  TMT
//
//  Created by Choi Minkyeong on 11/4/24.
//

import SwiftUI
import PhotosUI

struct NotUploadedView: View {
    @StateObject private var inputDisplayModel = InputDisplayModel()
    @State private var pickedItem: PhotosPickerItem? = nil
    @State private var showingAlert = false
    @State private var tag: Int? = nil
    
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
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
                
                NavigationLink(destination: ScannedJourneyInfoView(scannedJourneyInfo: $inputDisplayModel.scannedJourneyInfo).environmentObject(inputDisplayModel), tag: 1, selection: self.$tag) {
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
                        .foregroundStyle(Color.Basic.yellow600)
                    }
                }
                .onChange(of: pickedItem) {
                    inputDisplayModel.loadImage(from: pickedItem, viewCategory: "NotUploadedView") {
                        if !inputDisplayModel.showAlertScreen {
                            self.tag = 1
                        }
                    }
                }
                .alert("Failed to recognize the image.", isPresented: $inputDisplayModel.showAlertScreen) {
                    Button {
                        inputDisplayModel.showAlertScreen = false
                    } label: {
                        Text("Reupload")
                            .foregroundStyle(.blue)
                    }
                } message: {
                    Text("Image recognition failed during upload. Please upload the image again.")
                }
            }
            
            if inputDisplayModel.isLoading {
                ProgressView()
            }
        }
    }
}
