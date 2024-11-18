//
//  ButtonComponent.swift
//  TMT
//
//  Created by 김유빈 on 10/31/24.
//

import SwiftUI

struct PrimaryButton: View {
    var title: String
    var color: Color = .brandPrimary
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            RoundedRectangle(cornerRadius: 8)
                .overlay {
                    Text(title)
                        .foregroundStyle(.basicBlack)
                        .font(.system(size: 18, weight: .medium)) // TODO: 서체 수정
                        .padding(10)
                }
                .foregroundStyle(color)
                .frame(height: 52)
        }
    }
}

#Preview {
    PrimaryButton(title: "Continue", color: .blue) { }
}
