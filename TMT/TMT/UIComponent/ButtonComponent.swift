//
//  ButtonComponent.swift
//  TMT
//
//  Created by 김유빈 on 10/31/24.
//

import SwiftUI

struct PrimaryButton: View {
    var title: String
    var color = Color.blue // TODO: 디폴트 색상 수정하기
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            RoundedRectangle(cornerRadius: 8)
                .overlay {
                    Text(title)
                        .foregroundStyle(.white)
                        .font(.system(size: 18, weight: .medium))
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
