//
//  Color.swift
//  TMT
//
//  Created by 김유빈 on 11/13/24.
//

import SwiftUI

extension ShapeStyle where Self == Color {
    // MARK: Basic
    static var basicBlack: Self { Color("Basic/black") }
    static var basicBlackOpacity40: Self { Color("Basic/blackOpacity40") }
    static var basicBlackOpacity60: Self { Color("Basic/blackOpacity60") }
    static var basicBlackOpacity80: Self { Color("Basic/blackOpacity80") }
    static var basicWhite: Self { Color("Basic/white") }
    static var basicWhiteOpacity30: Self { Color("Basic/whiteOpacity30") }

    // MARK: Brand
    static var brandBackground: Self { Color("Brand/background") }
    static var backgroundDynamic: Self { Color("Brand/backgroundDynamic")}
    static var backgroundModal: Self { Color("Brand/backgroundModal")}
    static var backgroundOnboarding: Self { Color("Brand/backgroundOnboarding")}
    static var busStopLine: Self { Color("Brand/busStopLine")}
    static var busStopSelect: Self { Color("Brand/busStopSelect")}
    static var busStopUnselect: Self { Color("Brand/busStopUnselect")}
    static var brandPrimary: Self { Color("Brand/primary") }
    static var brandPrimaryOpacity70: Self { Color("Brand/primaryOpacity70") }
    static var textDefault: Self { Color("Brand/textDefault")}
    static var textLeft: Self { Color("Brand/textLeft")}
    static var toolTipBackground: Self { Color("Brand/toolTipBackground")}
    
    // MARK: Bus
    static var busBlue: Self { Color("Bus/blue") }
    static var busGreen: Self { Color("Bus/green") }
    static var busOliveGreen: Self { Color("Bus/olivegreen") }
    static var busRed: Self { Color("Bus/red") }
}
