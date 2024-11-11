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
    @Binding var selectedImage: UIImage?
    @Binding var scannedJourneyInfo: String
    @Binding var isLoading: Bool
    
    var body: some View {
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
                Task {
                    if let data = try? await pickedItem?.loadTransferable(type: Data.self),
                       let image = UIImage(data: data) {
                        selectedImage = image
                        OCRService.shared.startOCR(image: image) { info in
                            isLoading = false
                            if !info.isEmpty {
                                scannedJourneyInfo = info
                            }
                        }
                    }
                }
            }
        }
    }
}
