//
//  OnboardingIntroView.swift
//  TMT
//
//  Created by 김유빈 on 11/20/24.
//

import SwiftUI

struct OnboardingIntroView: View {
    private let title = "BusDot helps\nnot miss your stop."
    let screenMode: String
    
    var body: some View {
        let fileName = screenMode == "Light" ? "BusDotIntro" : "BusDotIntroDark"
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.system(size: 28, weight: .bold)) // TODO: 서체 수정하기
                .padding(.top, 61)
                .padding(.horizontal, 24)
            
            Spacer()
            
            LottieView(animationFileName: fileName, loopMode: .loop)
                .frame(minHeight: 460)
                .padding(.bottom, 169)
        }
    }
}

#Preview {
    OnboardingIntroView(screenMode: "Dark")
}
