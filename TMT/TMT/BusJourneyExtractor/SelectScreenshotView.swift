//
//  SelectScreenshotView.swift
//  TMT
//
//  Created by Choi Minkyeong on 10/24/24.
//

import SwiftUI

struct SelectScreenshotView: View {
    @State private var selectedImage: UIImage?
    @State private var isImagePickerPresented = false
    @State private var receivedText: String = ""
    
    var body: some View {
        VStack {
            Button("이미지 선택") {
                isImagePickerPresented = true
            }
            .padding()
            
            if selectedImage != nil {
                    ScanJourneyVCRepresentable(image: $selectedImage)
                        .padding()
                        .multilineTextAlignment(.leading)
            } else {
                Text("이미지를 선택하세요.")
                    .foregroundColor(.gray)
                    .padding()
            }
        }
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePicker(selectedImage: $selectedImage)
        }
    }
}
