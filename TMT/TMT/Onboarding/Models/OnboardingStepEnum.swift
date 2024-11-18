//
//  OnboardingStepEnum.swift
//  TMT
//
//  Created by 김유빈 on 10/31/24.
//

enum OnboardingStep: CaseIterable {
    case onboarding1
    case onboarding2
    case onboarding3
    
    var title: String {
        switch self {
        case .onboarding1: return "Prepare the screenshot"
        case .onboarding2: return "Make the route is centered."
        case .onboarding3: return "Upload it and done!"
        }
    }
    
    var description: String {
        switch self {
        case .onboarding1: return "Capture the bus route screen from the map app."
        case .onboarding2: return "By default, the route you want in the center of the screenshot is selected."
        case .onboarding3: return "Recognizing the information below to retrieve your bus information."
        }
    }
    
    var image: String {
        switch self {
        case .onboarding1: return "Onboarding1"
        case .onboarding2: return "Onboarding2"
        case .onboarding3: return "Onboarding3"
        }
    }
}
