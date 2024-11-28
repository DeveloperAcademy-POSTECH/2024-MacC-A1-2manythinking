//
//  OnboardingModalView.swift
//  TMT
//
//  Created by 김유빈 on 11/20/24.
//

import SwiftUI

struct InformationModalView: View {
    @Binding var isShowingInformation: Bool
    @Environment(\.openURL) var openLink
    
    private let title = "Prepare your screenshot"
    private let description = "If you don't have one,\ngo to NAVER Map and take a screenshot."
    private let filledButtonTitle = "Go to Naver Map"
    private let outlinedButtonTitle = "I have a screenshot"
    
    var body: some View {
        ZStack {
            Color.basicBlackOpacity60
            
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .foregroundStyle(.textDefault)
                    .font(.system(size: 24, weight: .bold)) // TODO: 서체 수정
                
                Text(description)
                    .foregroundStyle(.brandPrimary)
                    .font(.system(size: 16, weight: .medium)) // TODO: 서체 수정
                    .padding(.top, -4)
                    .padding(.bottom, 2)
                
                
                Image("OnboardingModal")
                    .resizable()
                    .scaledToFit()
                    .frame(minHeight: 230)
                
                FilledButton(title: filledButtonTitle) {
                    openNaverMap()
                }
                
                OutlinedButton(title: outlinedButtonTitle) {
                    isShowingInformation = false
                }
            }
            .padding(16)
            .background {
                Color.backgroundModal
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
            
            isShowingInformation = false
        } else {
            openLink(URL(string: "https://apps.apple.com/kr/app/naver-map-navigation/id311867728")!)
            
            isShowingInformation = false
        }
    }
}

#Preview {
    InformationModalView(isShowingInformation: .constant(true))
}
