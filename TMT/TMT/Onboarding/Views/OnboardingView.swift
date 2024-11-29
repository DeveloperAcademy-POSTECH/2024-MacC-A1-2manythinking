//
//  OnboardingView.swift
//  TMT
//
//  Created by 김유빈 on 10/31/24.
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var locationManager: LocationManager
    @State private var currentPage = 0
    @Binding var shouldShowOnboarding: Bool
    
    var body: some View {
        ZStack(alignment: .bottom) {
            onboardingTabView()
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
}
