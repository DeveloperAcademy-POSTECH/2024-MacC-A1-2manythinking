//
//  ButtonComponent.swift
//  TMT
//
//  Created by 김유빈 on 10/31/24.
//

import SwiftUI

// TODO: 생각해보기
struct FilledButton: View {
    var title: String
    var fillColor: Color = .brandPrimary
    var textColor: Color = .basicBlack
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(fillColor)
                .overlay {
                    Text(title)
                        .foregroundStyle(textColor)
                        .font(.system(size: 18, weight: .medium)) // TODO: 서체 수정
                        .padding(10)
                }
                .frame(height: 52)
        }
    }
}

struct OutlinedButton: View {
    var title: String
    var strokeColor: Color = .yellow600
    var textColor: Color = .yellow600
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            RoundedRectangle(cornerRadius: 8)
                .stroke(strokeColor, lineWidth: 1)
                .background(.basicWhite)
                .overlay {
                    Text(title)
                        .foregroundStyle(textColor)
                        .font(.system(size: 18, weight: .medium)) // TODO: 서체 수정
                        .padding(10)
                }
                .frame(height: 52)
        }
    }
}

#Preview {
    FilledButton(title: "Go !") { }
    OutlinedButton(title: "Test !") { }
}
