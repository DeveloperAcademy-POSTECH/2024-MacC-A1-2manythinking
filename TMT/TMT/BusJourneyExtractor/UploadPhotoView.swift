//
//  SelectScreenshotView.swift
//  TMT
//
//  Created by Choi Minkyeong on 10/24/24.
//

import SwiftUI
import PhotosUI

struct UploadPhotoView: View {
    @State private var scannedJourneyInfo: String = ""
    @State private var selectedImage: UIImage? = nil
    @State private var isLoading: Bool = false
    @State private var showingAlert = false
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Spacer()
                    Image(systemName: "info.circle")
                        .padding(.trailing, 16)
                }
                .frame(height: 44)
                
                if scannedJourneyInfo == ",," {
                    NotUploadedView(selectedImage: $selectedImage, scannedJourneyInfo: $scannedJourneyInfo, isLoading: $isLoading)
                        .onAppear {
                            self.showingAlert = true
                        }
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text("Failed to recognize the image."), message: Text("Image recognition failed during upload. Please upload the image again."), dismissButton: .default(Text("Reupload")))
                    }
                } else if !scannedJourneyInfo.isEmpty {
                    ScrollView {
                        UploadedPhotoView(selectedImage: $selectedImage)
                        ScannedJourneyInfoView(scannedJourneyInfo: $scannedJourneyInfo)
                    }
                } else {
                    if isLoading {
                        ZStack {
                            NotUploadedView(selectedImage: $selectedImage, scannedJourneyInfo: $scannedJourneyInfo, isLoading: $isLoading)
                                .disabled(isLoading)
                            ProgressView()
                        }
                    }
                    else {
                        NotUploadedView(selectedImage: $selectedImage, scannedJourneyInfo: $scannedJourneyInfo, isLoading: $isLoading)
                    }
                }
                Spacer()
            }
        }
        .padding(.horizontal, 16)
        .toolbar {
            Button {
                // 온보딩 뷰 연결시키기
                print("Execute on-boarding view")
            } label: {
                Label("Info", systemImage: "info.circle")
                    .font(.title2)
            }
        }
    }
    
    
}
