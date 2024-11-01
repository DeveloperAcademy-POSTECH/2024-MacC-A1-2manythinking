//
//  OnboardingStepView.swift
//  TMT
//
//  Created by 김유빈 on 11/1/24.
//

import SwiftUI

struct OnboardingStepView: View {
    var step: OnboardingStep
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(step.title)
                .font(.system(size: 22, weight: .bold)) // TODO: 서체 수정하기
            
            Text(step.description)
                .font(.system(size: 16)) // TODO: 서체 수정하기
                .multilineTextAlignment(.leading)
                .padding(.bottom, 6)
            
            Image(step.image)
                .resizable()
                .frame(height: 329)
        }
    }
}

#Preview {
    let data = OnboardingStep.onboarding1
    OnboardingStepView(step: data)
}
