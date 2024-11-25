//
//  OnboardingView.swift
//  TMT
//
//  Created by 김유빈 on 10/31/24.
//

import SwiftUI

struct OnboardingView: View {
    @Binding var shouldShowOnboarding: Bool
    
    @State private var currentPage = 0
    
    var body: some View {
        ZStack(alignment: .bottom) {
            onboardingTabView()
                .onAppear {
                    requestNotificationPermission()
                }
            
            if onboardingButtonTitle == "Next" {
                OutlinedButton(title: onboardingButtonTitle) {
                    goToNextPage()
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 53)
            } else {
                FilledButton(title: onboardingButtonTitle) {
                    goToNextPage()
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 53)
            }
        }
        .ignoresSafeArea(.all)
        .background(.basicWhite)
    }
    
    private var onboardingButtonTitle: String {
        switch currentPage {
        case 0:
            return "Let's GO"
        case OnboardingStep.allCases.count:
            return "Okay, I got it"
        default:
            return "Next"
        }
    }
    
    private func onboardingTabView() -> some View {
        TabView(selection: $currentPage) {
            OnboardingIntroView()
                .tag(0)
            
            ForEach(OnboardingStep.allCases.indices, id: \.self) { index in
                OnboardingStepView(step: OnboardingStep.allCases[index])
                    .tag(index + 1)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                        .disabled(true)
    }
    
    private func goToNextPage() {
        if currentPage < OnboardingStep.allCases.count {
            currentPage += 1
        } else {
            shouldShowOnboarding = false
        }
    }
    
    private func requestNotificationPermission() {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                if let error = error {
                    print("알림 권한 요청 실패: \(error)")
                } else {
                    print("알림 권한 요청 결과: \(granted)")
                }
            }
        }
}

#Preview {
    OnboardingView(shouldShowOnboarding: .constant(true))
}
