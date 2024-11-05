//
//  UploadedPhoto.swift
//  TMT
//
//  Created by Choi Minkyeong on 11/5/24.
//

import SwiftUI

struct UploadedPhotoView: View {
    @Binding var selectedImage: UIImage?
    
    var body: some View {
        VStack {
            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, minHeight: 360, maxHeight: 360, alignment: .center)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .inset(by: 0.75)
                            .stroke(.gray, lineWidth: 1.5)
                    )
                    .clipped()
                    .padding(.bottom, 10)
            } else {
                Text("Failed to load image.")
                    .foregroundColor(.gray)
                    .padding(.bottom, 10)
            }
        }
    }
}
