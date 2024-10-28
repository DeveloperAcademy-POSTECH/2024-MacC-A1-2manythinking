//
//  SelectScreenshotView.swift
//  TMT
//
//  Created by Choi Minkyeong on 10/24/24.
//

import PhotosUI
import SwiftUI

struct SelectScreenshotView: View {
    @State private var selectedImage: UIImage?
    @State private var pickedItem: PhotosPickerItem?
    
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
                        if let data = try? await newItem.loadTransferable(type: Data.self),
                           let image = UIImage(data: data) {
                            selectedImage = image
                        } else {
                            print("이미지 변환에 실패했습니다.")
                        }
                    }
                }
            }
            
            if pickedItem != nil {
                ScanJourneyVCRepresentable(image: $selectedImage)
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
