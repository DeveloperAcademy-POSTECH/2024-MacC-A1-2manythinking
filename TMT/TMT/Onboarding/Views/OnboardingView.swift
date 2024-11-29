//
//  OnboardingView.swift
//  TMT
//
//  Created by 김유빈 on 10/31/24.
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var locationManager: LocationManager
    @Environment(\.colorScheme) var colorScheme: ColorScheme
  
    @State private var currentPage = 0
    @Binding var shouldShowOnboarding: Bool
    
    var body: some View {
        let screenMode = colorScheme == .dark ? "Dark" : "Light"
        
        ZStack(alignment: .bottom) {
            onboardingTabView(screenMode: screenMode)
                .onAppear {
                         NotificationManager.shared.requestNotificationPermission()
                         locationManager.requestPermission()
                }
                .alert(isPresented: $locationManager.showSettingsAlert) {
                    Alert(
                        title: Text("Location access is not available."),
                        message: Text("Go to your app settings to adjust location access."),
                        primaryButton: .default(Text("Go to Settings")) {
                            if let url = URL(string: UIApplication.openSettingsURLString) {
                                UIApplication.shared.open(url)
                            }
                        },
                        secondaryButton: .cancel(Text("Cancel"))
                    )
                }
            
            if onboardingButtonTitle == "Next" {
                if screenMode == "Light" {
                    OutlinedButton(title: onboardingButtonTitle) {
                        goToNextPage()
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 53)
                } else {
                    OutlinedButton(title: onboardingButtonTitle, strokeColor: .brandPrimary, textColor: .basicWhite) {
                        goToNextPage()
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 53)
                }
            } else {
                FilledButton(title: onboardingButtonTitle) {
                    goToNextPage()
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 53)
            }
            
        }
        .ignoresSafeArea(.all)
        .background(.brandBackground)
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
    
    private func onboardingTabView(screenMode: String) -> some View {
        TabView(selection: $currentPage) {
            OnboardingIntroView(screenMode: screenMode)
                .tag(0)
            
            ForEach(OnboardingStep.allCases.indices, id: \.self) { index in
                OnboardingStepView(step: OnboardingStep.allCases[index], screenMode:  screenMode)
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
}
