//
//  UIApplication.swift
//  TMT
//
//  Created by 김유빈 on 12/3/24.
//

import Foundation
import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector (UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
