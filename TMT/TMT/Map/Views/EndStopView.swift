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
                .frame(width: 355, height: 40.2)
                .offset(y: -10)
                .background {
                    RoundedRectangle(cornerRadius: 20)
                        .trim(from: 0.5, to: 1)
                        .foregroundStyle(colors.backgroundColor)
                }
            
            VStack(alignment: .leading, spacing: 0) {
                Text("Korean")
                    .foregroundStyle(.grey200)
                    .font(.footnote)
                    .padding(.top, 5.34)
                Text("\(endStopNameKorean)")
                    .foregroundStyle(.yellow900)
                    .font(.title2)
                    .fontWeight(.bold)
                Text("[\(endStopNameRomanized)]")
                    .foregroundStyle(.yellow900)
                    .font(.footnote)
                Divider()
                    .foregroundStyle(.grey100)
                    .padding(.vertical, 9)
                Text("English")
                    .foregroundStyle(.grey200)
                    .font(.footnote)
                Text("\(endStopNameNaver)")
                    .foregroundStyle(.yellow900)
                    .font(.title2)
                    .fontWeight(.bold)
            }
            .padding(.leading, 16)
            .padding(.bottom, 11.48)
            .frame(width: 355, height: 145)
            .background {
                UnevenRoundedRectangle(cornerRadii: .init(
                    topLeading: 0,
                    bottomLeading: 15,
                    bottomTrailing: 15,
                    topTrailing: 0
                ))
                .foregroundStyle(.basicWhite)
            }
            .offset(y: -20.1)
        }
    }
    
    /// EndStopView의 메인 컬러를 판단합니다.
    private func mainColor(remainingStops: Int) -> (backgroundColor: Color, leftStopNumberColor: Color, leftStopTextColor: Color, destinationColor: Color, pinImage: String) {
        let status = StopStatusEnum(remainingStops: remainingStops)
        return (status.backgroundColor, status.leftStopNumberColor, status.leftStopTextColor, status.destinationColor, status.pinImage)
    }
}

#Preview {
    EndStopView(endStopNameKorean: "포항제철고등학교", endStopNameRomanized: "[Pohang Je-cheol Go-deung-hak-gyo", endStopNameNaver: "Pohang Jecheol High School", remainingStops: 4)
}
