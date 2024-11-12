//
//  RemainingStopsEnum.swift
//  TMT
//
//  Created by Choi Minkyeong on 11/2/24.
//

import SwiftUI

enum StopStatusEnum {
    case oneOrZeroStopsRemaining, twoStopsRemaining, threeStopsRemaining, defaultStatus
    
    init(remainingStops: Int) {
        switch remainingStops {
        case 0...1:
            self = .oneOrZeroStopsRemaining
        case 2:
            self = .twoStopsRemaining
        case 3:
            self = .threeStopsRemaining
        default:
            self = .defaultStatus
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .oneOrZeroStopsRemaining:
            return Color.StopLeft.left1
        case .twoStopsRemaining:
            return Color.StopLeft.left2
        case .threeStopsRemaining:
            return Color.StopLeft.left3
        case .defaultStatus:
            return .white
        }
    }
    
    var textColor: Color {
        switch self {
        case .oneOrZeroStopsRemaining, .twoStopsRemaining, .threeStopsRemaining:
            return .white
        case .defaultStatus:
            return Color.Basic.yellow600
        }
    }
    
    var subTextColor: Color {
        switch self {
        case .oneOrZeroStopsRemaining, .twoStopsRemaining, .threeStopsRemaining:
            return .white
        case .defaultStatus:
            return Color.Basic.grey400
        }
    }
    
    var pinImage: String {
        switch self {
        case .oneOrZeroStopsRemaining, .twoStopsRemaining, .threeStopsRemaining:
            return "PinWhite"
        case .defaultStatus:
            return "PinYellow"
        }
    }
}
