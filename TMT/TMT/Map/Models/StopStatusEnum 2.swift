//
//  StopStatusEnum.swift
//  TMT
//
//  Created by Choi Minkyeong on 11/2/24.
//

import SwiftUI

enum StopStatusEnum2 {
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
            return .left1
        case .twoStopsRemaining:
            return .left2
        case .threeStopsRemaining:
            return .left3
        case .defaultStatus:
            return .yellow500
        }
    }
    
    var leftStopNumberColor: Color {
        switch self {
        case .oneOrZeroStopsRemaining:
            return .left1
        case .twoStopsRemaining:
            return .left2
        case .threeStopsRemaining:
            return .left3
        case .defaultStatus:
            return .basicBlack
        }
    }
    
    var leftStopTextColor: Color {
        switch self {
        case .oneOrZeroStopsRemaining:
            return .left1
        case .twoStopsRemaining:
            return .left2
        case .threeStopsRemaining:
            return .left3
        case .defaultStatus:
            return .grey300
        }
    }
    
    var destinationColor: Color {
        switch self {
        case .oneOrZeroStopsRemaining, .twoStopsRemaining, .threeStopsRemaining:
            return .basicWhite
        case .defaultStatus:
            return .yellow900
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
