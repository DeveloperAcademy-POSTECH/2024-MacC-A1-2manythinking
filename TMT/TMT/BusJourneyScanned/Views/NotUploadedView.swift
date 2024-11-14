//
//  NotUploadedView.swift
//  TMT
//
//  Created by Choi Minkyeong on 11/4/24.
//

import SwiftUI
import PhotosUI

struct NotUploadedView: View {
    @State private var pickedItem: PhotosPickerItem? = nil
    @State private var scannedJourneyInfo: (busNumber: String, startStop: String, endStop: String) = ("", "", "")
    @State private var selectedImage: UIImage? = nil
    @State private var isLoading: Bool = false
    @State private var hasError: Bool = false
    @State private var showingAlert = false
    @State private var tag: Int? = nil
    
    
    let ocrStarter = OCRStarterManager()
    
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
                
                NavigationLink(destination: ScannedJourneyInfoView(scannedJourneyInfo: $scannedJourneyInfo, selectedImage: $selectedImage), tag: 1, selection: self.$tag) {
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
                    loadImage(from: pickedItem)
                }
            }
            .alert("Failed to recognize the image.", isPresented: $hasError) {
                Button {
                    hasError = false
                } label: {
                    Text("Reupload")
                        .foregroundStyle(.blue)
                }
            } message: {
                Text("Image recognition failed during upload. Please upload the image again.")
            }
            
            if isLoading {
                ProgressView()
            }
        }
    }
    
    private func loadImage(from item: PhotosPickerItem?) {
        Task {
            guard let item = item else { return }
            if let data = try? await item.loadTransferable(type: Data.self),
               let image = UIImage(data: data) {
                selectedImage = image
                isLoading = true
                hasError = false
                
                ocrStarter.startOCR(image: image) { info in
                    isLoading = false
                    if info.busNumber.isEmpty && info.startStop.isEmpty && info.endStop.isEmpty {
                        hasError = true
                    } else {
                        print("info: \(info)")
                        scannedJourneyInfo = ocrStarter.splitScannedInfo(scannedJourneyInfo: info)
                        print("scannedJourneyInfo: \(scannedJourneyInfo)")
                        self.tag = 1
                    }
                }
            }
        }
    }
}
