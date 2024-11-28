//
//  OnboardingStepView.swift
//  TMT
//
//  Created by 김유빈 on 11/1/24.
//

import SwiftUI

struct OnboardingStepView: View {
    var step: OnboardingStep
    let screenMode: String
    
    var body: some View {
        ZStack {
            if step == .introFinish {
                screenMode == "Light" ? Color.yellow50.ignoresSafeArea(.all) : Color.brandBackground.ignoresSafeArea(.all)
            }
            
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(step.title)
                            .font(.system(size: 28, weight: .bold)) // TODO: 서체 수정하기
                            .foregroundStyle(.textDefault)
                        
                        if let description = step.description {
                            Text(description)
                                .multilineTextAlignment(.leading)
                                .font(.system(size: 24, weight: .bold))
                                .foregroundStyle(.brandPrimary)
                                .padding(.bottom, 6)
                        }
                    }
                    .padding(.top, 61)
                    .padding(.horizontal, 24)
                    
                    Spacer()
                }
                
                Spacer()
                
                if screenMode == "Light" {
                                    LottieView(animationFileName: step.lightImage, loopMode: .loop)
                                        .frame(maxWidth: 270, maxHeight: 531)
                                        .padding(.bottom, 48)
                                } else {
                                    LottieView(animationFileName: step.darkImage, loopMode: .loop)
                                        .frame(maxWidth: 270, maxHeight: 531)
                                        .padding(.bottom, 48)
                                }
            }
        }
    }
}

#Preview {
    OnboardingStepView(step: OnboardingStep.goNaverMap, screenMode: "Dark")
}
#Preview {
    OnboardingStepView(step: OnboardingStep.capture, screenMode: "Dark")
}
#Preview {
    OnboardingStepView(step: OnboardingStep.introFinish, screenMode: "Dark")
}
