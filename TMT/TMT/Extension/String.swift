//
//  String.swift
//  TMT
//
//  Created by 김유빈 on 11/13/24.
//

extension String {
    func matches(_ pattern: String) -> Bool {
        return self.range(of: pattern, options: .regularExpression) != nil
    }
}
