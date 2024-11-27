//
//  StopStatusEnum.swift
//  TMT
//
//  Created by Choi Minkyeong on 11/2/24.
//

import SwiftUI

enum StopStatusEnum {
    case zeroStopLeft, oneStopLeft, twoStopsLeft, threeStopsLeft, defaultStatus
    
    init(remainingStops: Int) {
        switch remainingStops {
        case 0:
            self = .zeroStopLeft
        case 1:
            self = .oneStopLeft
        case 2:
            self = .twoStopsLeft
        case 3:
            self = .threeStopsLeft
        default:
            self = .defaultStatus
        }
    }
    
    var statusColor: Color {
        switch self {
        case .zeroStopLeft:
            return .left0
        case .oneStopLeft:
            return .left1
        case .twoStopsLeft:
            return .left2
        case .threeStopsLeft:
            return .left3
        case .defaultStatus:
            return .brandPrimary
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .zeroStopLeft:
            return .left0
        case .oneStopLeft:
            return .left1
        case .twoStopsLeft:
            return .left2
        case .threeStopsLeft:
            return .left3
        case .defaultStatus:
            return .basicWhite
        }
    }
    
    var leftStopNumberColor: Color {
        switch self {
        case .zeroStopLeft:
            return .left0
        case .oneStopLeft, .twoStopsLeft, .threeStopsLeft:
            return .basicWhite
        case .defaultStatus:
            return .basicBlack
        }
    }
    
    var leftStopTextColor: Color {
        switch self {
        case .zeroStopLeft:
            return .left0
        case .oneStopLeft, .twoStopsLeft, .threeStopsLeft:
            return .basicWhite
        case .defaultStatus:
            return .grey300
        }
    }
    
    var destinationColor: Color {
        switch self {
        case .zeroStopLeft, .oneStopLeft, .twoStopsLeft, .threeStopsLeft:
            return .basicWhite
        case .defaultStatus:
            return .yellow900
        }
    }
}
