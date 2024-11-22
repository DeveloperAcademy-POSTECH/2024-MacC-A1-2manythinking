//
//  LottieView.swift
//  TMT
//
//  Created by 김유빈 on 11/19/24.
//

import SwiftUI

import Lottie

struct LottieView: UIViewRepresentable {
    
    var animationFileName: String
    let loopMode: LottieLoopMode
        
    func makeUIView(context: Context) -> Lottie.LottieAnimationView {
        let animationView = LottieAnimationView(name: animationFileName)
        animationView.loopMode = loopMode
        animationView.play()
        animationView.contentMode = .scaleAspectFill
        return animationView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) { }
}
