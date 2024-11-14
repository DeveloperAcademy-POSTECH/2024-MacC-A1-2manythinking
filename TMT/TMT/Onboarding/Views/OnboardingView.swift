//
//  OnboardingView.swift
//  TMT
//
//  Created by 김유빈 on 10/31/24.
//

import SwiftUI

struct OnboardingView: View {
    @Binding var isShowingOnboarding: Bool
    @State private var currentPage = 0
    
    init(isShowingOnboarding: Binding<Bool>) {
        UIPageControl.appearance().currentPageIndicatorTintColor = .black
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.3)
        self._isShowingOnboarding = isShowingOnboarding
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.basicBlack.opacity(0.5)
            
            VStack(spacing: 0) {
                xmarkButton()
                
                onboardingTabView()
                    .padding(.bottom, 10)
                
                PrimaryButton(title: onboardingButtonTitle) {
                    if currentPage < OnboardingStep.allCases.count - 1 {
                        currentPage += 1
                    } else {
                        isShowingOnboarding.toggle()
                    }
                }
            }
            .padding(16)
            .background {
                Color.basicWhite
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .frame(maxHeight: 590)
            .padding([.horizontal, .top], 16)
            .padding(.bottom, 34)
        }
        .ignoresSafeArea(.all)
    }
    
    private var onboardingButtonTitle: String {
        currentPage == OnboardingStep.allCases.count - 1 ? "Done" : "Continue"
    }
    
    private func xmarkButton() -> some View {
        HStack {
            Spacer()
            Button {
                isShowingOnboarding = false
            } label: {
                Image(systemName: "xmark.circle")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(.grey300)
            }
        }
    }
    
    private func onboardingTabView() -> some View {
        TabView(selection: $currentPage) {
            ForEach(OnboardingStep.allCases.indices, id: \.self) { index in
                OnboardingStepView(step: OnboardingStep.allCases[index])
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
    }
}

#Preview {
    OnboardingView(isShowingOnboarding: .constant(true))
}
