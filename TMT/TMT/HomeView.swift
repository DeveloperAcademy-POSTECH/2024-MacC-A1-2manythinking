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
    @StateObject private var imageHandler: ImageHandlerModel = ImageHandlerModel()
    
    @State private var isShowingOnboarding = false
    @State var path: [String] = []
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack(alignment: .bottom) {
                Color.basicWhite
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    NotUploadedView(path: $path)
                    Spacer()
                }
                .padding(.horizontal, 16)
                
                if isShowingOnboarding {
                    OnboardingModalView(isShowingOnboarding: $isShowingOnboarding)
                        .onDisappear {
                            hasSeenOnboarding = true
                        }
                }
            }
            .toolbar {
                Button {
                    isShowingOnboarding = true
                } label: {
                    Image(systemName: "info.circle")
                        .foregroundStyle(.grey600)
                }
                .disabled(isShowingOnboarding)
            }
            .onAppear {
                if !hasSeenOnboarding {
                    isShowingOnboarding = true
                }
            }
        }
        .environmentObject(imageHandler)
    }
}

#Preview {
    HomeView()
}
