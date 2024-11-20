//
//  EndStopView.swift
//  TMT
//
//  Created by Choi Minkyeong on 11/1/24.
//

import SwiftUI

struct EndStopView: View {
    var endStopNameKorean: String
    var endStopNameRomanized: String
    var endStopNameNaver: String
    var remainingStops: Int
    
    var body: some View {
        let colors = mainColor(remainingStops: remainingStops)
        VStack(spacing: 0) {
            Text("Destination")
                .foregroundStyle(colors.destinationColor)
                .frame(width: 361, height: 38)
                .offset(y: -10)
                .background {
                    RoundedRectangle(cornerRadius: 20)
                        .trim(from: 0.5, to: 1)
                        .foregroundStyle(colors.backgroundColor)
                }
            
            BusStopDetailView(stopNameKorean: endStopNameKorean, stopNameRomanized: endStopNameRomanized, stopNameNaver: endStopNameNaver)
            .padding(.horizontal, 16)
            .padding(.top, 5)
            .padding(.bottom, 11.88)
            .frame(width: 361)
            .background {
                UnevenRoundedRectangle(cornerRadii: .init(
                    topLeading: 0,
                    bottomLeading: 15,
                    bottomTrailing: 15,
                    topTrailing: 0
                ))
                .foregroundStyle(.basicWhite)
            }
            .offset(y: -19)
        }
    }
    
    /// EndStopView의 메인 컬러를 판단합니다.
    private func mainColor(remainingStops: Int) -> (backgroundColor: Color, leftStopNumberColor: Color, leftStopTextColor: Color, destinationColor: Color) {
        let status = StopStatusEnum(remainingStops: remainingStops)
        return (status.backgroundColor, status.leftStopNumberColor, status.leftStopTextColor, status.destinationColor)
    }
}
