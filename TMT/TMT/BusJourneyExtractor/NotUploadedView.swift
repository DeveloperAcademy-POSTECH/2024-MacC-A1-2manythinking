//
//  NotUploadedView.swift
//  TMT
//
//  Created by Choi Minkyeong on 11/4/24.
//

import SwiftUI
import PhotosUI

struct NotUploadedView: View {
    @State private var pickedItem: PhotosPickerItem?
    @Binding var selectedImage: UIImage?
    @Binding var errorMessage: String?
    @Binding var scannedJourneyInfo: String
    
    private let ocrService = OCRService()
    
    var body: some View {
        VStack {
            HStack {
                Text("With Poling Bus,")
                    .font(.title)
                    .bold()
                Spacer()
            }
            .padding(.horizontal, 16)
            HStack {
                Text("Whether you don't know Korean,\nyou can know\nwhere to get off the bus.")
                    .padding(.bottom, 10)
                    .multilineTextAlignment(.leading)
                Spacer()
            }
            .padding(.horizontal, 16)
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
                        Image(systemName: "square.and.arrow.up")
                        Text("Upload Path Screenshot")
                    }.foregroundStyle(.yellow)
                }
                .padding(.horizontal, 16)
            }
            .onChange(of: pickedItem) { newItem in
                if let newItem {
                    Task {
                        scannedJourneyInfo = ""
                        errorMessage = nil
                        
                        if let data = try? await newItem.loadTransferable(type: Data.self),
                           let image = UIImage(data: data) {
                            selectedImage = image
                            
                            ocrService.startOCR(image: image) { info in
                                if !info.isEmpty {
                                    scannedJourneyInfo = info
                                }
                            }
                        } else {
                            errorMessage = "Failed to convert image."
                        }
                    }
                }
            }
        }
    }
}
