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
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Color.basicWhite
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    NotUploadedView()
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
