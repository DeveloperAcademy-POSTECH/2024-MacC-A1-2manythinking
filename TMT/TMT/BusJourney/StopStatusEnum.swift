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
            return .red
        case .twoStopsRemaining:
            return .orange
        case .threeStopsRemaining:
            return .yellow
        case .defaultStatus:
            return .white
        }
    }
    
    var textColor: Color {
        switch self {
        case .oneOrZeroStopsRemaining, .twoStopsRemaining, .threeStopsRemaining:
            return .white
        case .defaultStatus:
            return .orange
        }
    }
    
    var subTextColor: Color {
        switch self {
        case .oneOrZeroStopsRemaining, .twoStopsRemaining, .threeStopsRemaining:
            return .white
        case .defaultStatus:
            return .gray
        }
    }
    
    var pinImage: String {
        switch self {
        case .oneOrZeroStopsRemaining, .twoStopsRemaining, .threeStopsRemaining:
            return "pin_white"
        case .defaultStatus:
            return "pin_yellow"
        }
    }
}
