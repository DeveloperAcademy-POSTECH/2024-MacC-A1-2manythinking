//
//  SelectScreenshotView.swift
//  TMT
//
//  Created by Choi Minkyeong on 10/24/24.
//

import SwiftUI
import PhotosUI

struct UploadPhotoView: View {
    @State private var selectedImage: UIImage?
    @State private var pickedItem: PhotosPickerItem?
    @State private var scannedJourneyInfo: String = ""
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?
    
    private let ocrService = OCRService()
    
    var body: some View {
        VStack {
            PhotosPicker(
                selection: $pickedItem,
                matching: .screenshots
            ) {
                Text("Select a screenshot.")
            }
            .onChange(of: pickedItem) { newItem in
                if let newItem {
                    Task {
                        isLoading = true
                        scannedJourneyInfo = ""
                        errorMessage = nil
                        
                        if let data = try? await newItem.loadTransferable(type: Data.self),
                           let image = UIImage(data: data) {
                            selectedImage = image
                            
                            ocrService.startOCR(image: image) { info in
                                isLoading = false
                                if info.isEmpty {
                                    errorMessage = "No information found."
                                } else {
                                    scannedJourneyInfo = info
                                }
                            }
                        } else {
                            isLoading = false
                            errorMessage = "Failed to convert image."
                        }
                    }
                }
            }
            
            if isLoading {
                ProgressView("Analyzing...")
            } else if let error = errorMessage {
                Text(error).foregroundColor(.red)
            } else if !scannedJourneyInfo.isEmpty {
                Text(scannedJourneyInfo)
                    .padding()
                    .multilineTextAlignment(.leading)
            } else {
                Text("이미지를 선택하세요.")
                    .foregroundColor(.gray)
                    .padding()
            }
        }
    }
}
