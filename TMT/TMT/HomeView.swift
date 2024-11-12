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
    @State private var hasError: Bool = false
    @State private var showingAlert = false
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Color.white
                    .ignoresSafeArea()
                VStack(spacing: 0) {
                    if scannedJourneyInfo == "" && hasError {
                        NotUploadedView(selectedImage: $selectedImage, scannedJourneyInfo: $scannedJourneyInfo, isLoading: $isLoading, hasError: $hasError)
                            .onAppear {
                                self.showingAlert = true
                            }
                            .alert("Failed to recognize the image.", isPresented: $showingAlert) {
                                Button {
                                    scannedJourneyInfo = ""
                                    showingAlert = false
                                    hasError = false
                                } label: {
                                    Text("Reupload")
                                        .foregroundStyle(.blue)
                                }
                            } message: {
                                Text("Image recognition failed during upload. Please upload the image again.")
                            }
                    } else if !scannedJourneyInfo.isEmpty {
                        ScrollView {
                            UploadedPhotoView(selectedImage: $selectedImage)
                            ScannedJourneyInfoView(scannedJourneyInfo: $scannedJourneyInfo, selectedImage: $selectedImage, isLoading: $isLoading)
                        }
                    } else {
                        if isLoading {
                            ZStack {
                                NotUploadedView(selectedImage: $selectedImage, scannedJourneyInfo: $scannedJourneyInfo, isLoading: $isLoading, hasError: $hasError)
                                    .disabled(isLoading)
                                ProgressView()
                            }
                        }
                        else {
                            NotUploadedView(selectedImage: $selectedImage, scannedJourneyInfo: $scannedJourneyInfo, isLoading: $isLoading, hasError: $hasError)
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
