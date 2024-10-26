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
    
    // TODO: 처음에는 선택이라고 뜨고, 두번째부터는 다시 선택하기라고 띄우기
    var body: some View {
        VStack {
            Button("이미지 선택") {
                isImagePickerPresented = true
            }
            .padding()
            
            if selectedImage != nil {
                ScrollView {
                    ScanJourneyVCRepresentable(image: $selectedImage)
                        .padding()
                        .multilineTextAlignment(.leading)
                }
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
