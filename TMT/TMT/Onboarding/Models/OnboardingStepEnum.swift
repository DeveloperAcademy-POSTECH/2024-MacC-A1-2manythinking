//
//  OnboardingStepEnum.swift
//  TMT
//
//  Created by 김유빈 on 10/31/24.
//

enum OnboardingStep: CaseIterable {
    case goNaverMap
    case capture
    case introFinish
    
    var title: String {
        switch self {
        case .goNaverMap: return "Go to Naver Map's\nbus route."
        case .capture: return "Search and capture\nthe screenshot."
        case .introFinish: return "And upload it, Done!"
        }
    }
    
    var description: String? {
        switch self {
        case .goNaverMap: return nil
        case .capture: return nil
        case .introFinish: return "The route is\nautomatically entered!"
        }
    }
    
    var image: String {
        switch self {
        case .goNaverMap: return "GoNaverMap"
        case .capture: return "Capture"
        case .introFinish: return "IntroFinish"
        }
    }
}
