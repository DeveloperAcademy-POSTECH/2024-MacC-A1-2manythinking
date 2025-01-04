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
        case .goNaverMap: return "Find your bus route on\nNAVER Map."
        case .capture: return "Screenshot\nthe search result."
        case .introFinish: return "Then upload it!"
        }
    }
    
    var description: String? {
        switch self {
        case .goNaverMap: return nil
        case .capture: return nil
        case .introFinish: return "BusDot will automatically\nimport your bus route data"
        }
    }
    
    var lightImage: String {
        switch self {
        case .goNaverMap: return "GoNaverMap"
        case .capture: return "Capture"
        case .introFinish: return "IntroFinish"
        }
    }
    
    var darkImage: String {
        switch self {
        case .goNaverMap: return "GoNaverMapDark"
        case .capture: return "CaptureDark"
        case .introFinish: return "IntroFinishDark"
        }
    }
    
}
