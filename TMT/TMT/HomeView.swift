//
//  HomeView.swift
//  TMT
//
//  Created by 김유빈 on 9/29/24.
//

import SwiftUI
import PhotosUI

struct HomeView: View {
    @AppStorage("shouldShowOnboarding") var shouldShowOnboarding = true
    @StateObject private var imageHandler: ImageHandlerModel = ImageHandlerModel()
    
    @State private var isShowingInformation = false
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
                
                if isShowingInformation {
                    InformationModalView(isShowingInformation: $isShowingInformation)
                }
            }
            .toolbar {
                Button {
                    isShowingInformation = true
                } label: {
                    Image(systemName: "info.circle")
                        .foregroundStyle(.grey600)
                }
                .disabled(isShowingInformation)
            }
            .fullScreenCover(isPresented: $shouldShowOnboarding) {
                OnboardingView(shouldShowOnboarding: $shouldShowOnboarding)
            }
        }
        .environmentObject(imageHandler)
    }
}

#Preview {
    HomeView()
}
