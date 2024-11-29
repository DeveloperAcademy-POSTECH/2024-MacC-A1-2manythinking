//
//  PopoverView.swift
//  TMT
//
//  Created by Choi Minkyeong on 11/25/24.
//

import SwiftUI

struct PopoverView: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let curveWidth: CGFloat = 30
        let curveHeight: CGFloat = 13
        let bubbleCornerRadius: CGFloat = 14
        let curveStartX = rect.midX - curveWidth / 2
        
        path.move(to: CGPoint(x: curveStartX, y: curveHeight))
        
        path.addQuadCurve(
            to: CGPoint(x: rect.midX, y: 0),
            control: CGPoint(x: rect.midX + 3, y: -curveHeight)
        )
        
        path.addQuadCurve(
            to: CGPoint(x: curveStartX + curveWidth, y: curveHeight),
            control: CGPoint(x: rect.midX - 3, y: -curveHeight)
        )
        
        path.addRoundedRect(
            in: CGRect(x: 0, y: curveHeight, width: rect.width, height: rect.height - curveHeight),
            cornerSize: CGSize(width: bubbleCornerRadius, height: bubbleCornerRadius)
        )
        
        return path
    }
}
