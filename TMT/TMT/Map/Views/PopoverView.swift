//
//  PopoverView.swift
//  TMT
//
//  Created by Choi Minkyeong on 11/25/24.
//

import SwiftUI

struct SpeechBubbleShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        let triangleWidth: CGFloat = 19
        let triangleHeight: CGFloat = 19
        let triangleStartX = rect.midX - triangleWidth / 2
        let cornerRadius: CGFloat = 5
        
        // TODO: 화살표 수정하기...
        path.move(to: CGPoint(x: triangleStartX, y: triangleHeight))
        path.addQuadCurve(to: CGPoint(x: rect.midX, y: 0), control: CGPoint(x: rect.midX, y: -10)) // 좌측 둥근 곡선
                path.addQuadCurve(to: CGPoint(x: triangleStartX + triangleWidth, y: triangleHeight), control: CGPoint(x: rect.midX, y: -10))
        
        path.addRoundedRect(in: CGRect(x: 0, y: triangleHeight, width: rect.width, height: rect.height - triangleHeight),
                            cornerSize: CGSize(width: 14, height: 14))
        
        return path
    }
}
