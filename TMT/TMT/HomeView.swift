//
//  HomeView.swift
//  TMT
//
//  Created by 김유빈 on 9/29/24.
//

import SwiftUI
import PhotosUI

struct HomeView: View {
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding = false
    @State private var isShowingOnboarding = false
    @State private var scannedJourneyInfo: String = ""
    @State private var selectedImage: UIImage? = nil
    @State private var isLoading: Bool = false
    @State private var showingAlert = false
    
    init() {
        // TODO: blur 추가하기
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Color.white
                    .ignoresSafeArea()
                VStack(spacing: 0) {
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
                .padding(.horizontal, 16)
                
                if isShowingOnboarding {
                    OnboardingView(isShowingOnboarding: $isShowingOnboarding)
                        .onDisappear {
                            hasSeenOnboarding = true
                        }
                }
            }
            .toolbar {
                Button {
                    isShowingOnboarding = true
                } label: {
                    Label("Info", systemImage: "info.circle")
                        .font(.title2)
                }
            }
            .onAppear {
                if !hasSeenOnboarding {
                    isShowingOnboarding = true
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
