//
//  EndStopView.swift
//  TMT
//
//  Created by Choi Minkyeong on 11/1/24.
//

import SwiftUI

struct EndStopView: View {
    // 컬러 이넘으로 받아서 남은정류장별로 바꿔서 받기.
    var endStop: String
    var remainingStops: Int
    
    var body: some View {
        let colors = getMainColor(remainingStops: remainingStops)
            
            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        Image("\(colors.pinImage)")
                        Text("Destination")
                            .foregroundStyle(colors.subTextColor)
                    }
                    Text("Youngildae Beach")
                }
                .padding(.leading, 24)
                .padding(.vertical, 12)
                Spacer()
                HStack {
                    Text("20")
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
            .background(colors.backgroundColor)
            .cornerRadius(16)
        // TODO: shadow 값 물어보기
            .shadow(radius: 5)
        .frame(width: 361, height: 65)
    }
    
    /// EndStopView의 메인 컬러를 판단합니다.
    private func getMainColor(remainingStops: Int) ->  (backgroundColor: Color, textColor: Color, subTextColor: Color, pinImage: String) {
        var backgroundColor: Color = .white
        var textColor: Color = .orange
        var subTextColor: Color = .gray
        var pinImage: String = "pin_yellow"
        
        switch remainingStops {
        case 0...1:
            backgroundColor = .red
            textColor = .white
            subTextColor = .white
            pinImage = "pin_white"
        case 2:
            backgroundColor = .orange
            textColor = .white
            subTextColor = .white
            pinImage = "pin_white"
        case 3:
            backgroundColor = .yellow
            textColor = .white
            subTextColor = .white
            pinImage = "pin_white"
        default:
            backgroundColor = .white
            textColor = .orange
            subTextColor = .gray
            pinImage = "pin_yellow"
        }
        
        return (backgroundColor, textColor, subTextColor, pinImage)
    }
}

#Preview {
    EndStopView(endStop: "Youngildae Beach", remainingStops: 20)
}
