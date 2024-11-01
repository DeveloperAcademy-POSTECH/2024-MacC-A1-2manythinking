//
//  EndStopView.swift
//  TMT
//
//  Created by Choi Minkyeong on 11/1/24.
//

import SwiftUI

struct EndStopView: View {
    var endStop: String
    var remainingStops: Int
    
    var body: some View {
        let colors = getMainColor(remainingStops: remainingStops)
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(colors.backgroundColor)
                .frame(height: 65)
                .shadow(color: .black.opacity(0.25), radius: 2.5, x: 0, y: 2)
            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        Image("\(colors.pinImage)")
                        Text("Destination")
                            .foregroundStyle(colors.subTextColor)
                    }
                    Text("\(endStop)")
                }
                .padding(.leading, 24)
                .padding(.vertical, 12)
                
                Spacer(minLength: 24)
                
                HStack {
                    Text("\(remainingStops)")
                        .font(.title)
                        .bold()
                    VStack {
                        Spacer()
                        Text("left")
                    }
                }
                .frame(height: 18)
                .padding(.trailing, 24)
            }
            .foregroundStyle(colors.textColor)
            .cornerRadius(16)
        }
        .padding(.bottom, 18)
        .padding(.leading, 16.25)
        .padding(.trailing, 16.75)
    }
    
    /// EndStopView의 메인 컬러를 판단합니다.
    private func getMainColor(remainingStops: Int) -> (backgroundColor: Color, textColor: Color, subTextColor: Color, pinImage: String) {
        let status = StopStatusEnum(remainingStops: remainingStops)
        return (status.backgroundColor, status.textColor, status.subTextColor, status.pinImage)
    }
}

#Preview {
    EndStopView(endStop: "Youngildae Beach", remainingStops: 20)
}
