//
//  SelectScreenshotView.swift
//  TMT
//
//  Created by Choi Minkyeong on 10/24/24.
//

import SwiftUI
import PhotosUI

struct SelectScreenshotView: View {
    @State private var selectedImage: UIImage?
    @State private var pickedItem: PhotosPickerItem?
    @State private var busJourneyInfo: String = ""
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
                        busJourneyInfo = ""
                        errorMessage = nil
                        
                        if let data = try? await newItem.loadTransferable(type: Data.self),
                           let image = UIImage(data: data) {
                            selectedImage = image
                            
                            ocrService.startOCR(image: image) { info in
                                isLoading = false
                                if info.isEmpty {
                                    errorMessage = "No information found."
                                } else {
                                    busJourneyInfo = info
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
            } else if !busJourneyInfo.isEmpty {
                Text(busJourneyInfo)
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
