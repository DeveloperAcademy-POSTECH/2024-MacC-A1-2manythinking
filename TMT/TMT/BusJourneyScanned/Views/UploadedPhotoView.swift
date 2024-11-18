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
        VStack(spacing: 0) {
            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, minHeight: 360, maxHeight: 360, alignment: .center)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .inset(by: 0.75)
                            .stroke(.grey200, lineWidth: 1.5)
                    )
                    .clipped()
            } else {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white)
                    .stroke(.grey200, lineWidth: 1.5)
                    .frame(maxWidth: .infinity, minHeight: 360, maxHeight: 360, alignment: .center)
            }
        }
        .padding(.bottom, 10)
    }
}
