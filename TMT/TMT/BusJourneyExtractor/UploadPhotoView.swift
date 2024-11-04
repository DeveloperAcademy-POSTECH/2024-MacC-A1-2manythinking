//
//  SelectScreenshotView.swift
//  TMT
//
//  Created by Choi Minkyeong on 10/24/24.
//

import SwiftUI
import PhotosUI

struct UploadPhotoView: View {
    @State private var errorMessage: String?
    @State private var scannedJourneyInfo: String = ""
    @State private var selectedImage: UIImage? = nil
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Spacer()
                    Image(systemName: "info.circle")
                        .padding(.trailing, 16)
                }
                .frame(height: 44)
                
                if let error = errorMessage {
                    // TODO: 에러나는 경우 하이파이 추가하고 반영하기
                    Text(error).foregroundColor(.red)
                } else if !scannedJourneyInfo.isEmpty {
                    // scrollview
                    selectedImageView
                    ScannedJourneyInfoView(scannedJourneyInfo: $scannedJourneyInfo)
                } else {
                    NotUploadedView(selectedImage: $selectedImage, errorMessage: $errorMessage, scannedJourneyInfo: $scannedJourneyInfo)
                }
            }
        }
        .toolbar {
            Button {
                // 온보딩 뷰 연결시키기
                print("Execute on-boarding view")
            } label: {
                Label("Info", systemImage: "info.circle")
            }
        }
    }
    
    private var selectedImageView: some View {
        VStack {
            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill) // 프레임 사이즈에 맞게 이미지 사이즈 조정
                        .scaledToFill()
////                    .scaledToFill()      // 부모 뷰의 크기를 채우도록 확장
//                    .aspectRatio(1.0, contentMode: .fit) // 정사각형 비율 유지
////                    .clipped()            // 프레임 바깥 부분을 잘라냄
//                    .cornerRadius(8)      // 코너 반경 적용
                        .clipped()
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1.5)
                            .aspectRatio(1.0, contentMode: .fit)
                            // 회색 테두리 추가
                    )
//                    .clipped()
                    .padding(.horizontal, 16)
                    .padding(.bottom, 10)
            } else {
                Text("Failed to load image.")
                    .foregroundColor(.gray)
                    .padding(.bottom, 10)
            }
            Text("Please check if this is the right stop to get off.")
                .foregroundStyle(.yellow)
                .padding(.bottom, 26)
        }
        .padding(.horizontal, 16)
    }
}
