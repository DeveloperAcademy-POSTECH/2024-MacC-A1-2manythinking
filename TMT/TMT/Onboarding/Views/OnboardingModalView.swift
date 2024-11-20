//
//  OnboardingModalView.swift
//  TMT
//
//  Created by 김유빈 on 11/20/24.
//

import SwiftUI

struct OnboardingModalView: View {
    @Binding var isShowingOnboarding: Bool
    @Environment(\.openURL) var openLink

    var body: some View {
        ZStack {
            Color.basicBlackOpacity60
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Prepare your screenshot")
                    .foregroundStyle(.basicBlack)
                    .font(.system(size: 24, weight: .bold)) // TODO: 서체 수정
                
                Text("If you don't have a screenshot,\ngo to NAVER Map and take a screen capture")
                    .foregroundStyle(.brandPrimary)
                    .font(.system(size: 16, weight: .medium)) // TODO: 서체 수정
                    .padding(.top, -4)
                    .padding(.bottom, 2)
                
                
                Image("OnboardingModal")
                    .resizable()
                    .scaledToFit()
                    .frame(minHeight: 230)
                
                FilledButton(title: "Go to Naver Map") {
                    openNaverMap()
                }
                
                OutlinedButton(title: "I have a screenshot") {
                    isShowingOnboarding = false
                }
            }
            .padding(16)
            .background {
                Color.basicWhite
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .frame(minHeight: 590)
            .padding([.horizontal, .top], 16)
            .padding(.bottom, 34)
        }
        .ignoresSafeArea(.all)
    }
    
    private func openNaverMap() {
        if let openApp = URL(string: "navermap:"),
           UIApplication.shared.canOpenURL(openApp) {
            UIApplication.shared.open(openApp, options: [:], completionHandler: nil)
            isShowingOnboarding = false
        } else {
            openLink(URL(string: "https://apps.apple.com/kr/app/naver-map-navigation/id311867728")!)
            isShowingOnboarding = false
        }
    }
}

#Preview {
    OnboardingModalView(isShowingOnboarding: .constant(true))
}
