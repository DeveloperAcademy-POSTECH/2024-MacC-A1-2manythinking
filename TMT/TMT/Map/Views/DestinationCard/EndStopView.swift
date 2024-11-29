//
//  EndStopView.swift
//  TMT
//
//  Created by Choi Minkyeong on 11/1/24.
//

import SwiftUI

struct EndStopView: View {
    @Binding var busStopDetail: BusStop
    @Binding var colors: (statusColor: Color, leftStopNumberColor: Color, destinationColor: Color)
    
    var remainingStops: Int = 0
    
    var body: some View {
        
        VStack(spacing: 0) {
            Text("Destination")
                .foregroundStyle(colors.destinationColor)
                .font(.system(size: 14, weight: .medium))
                .frame(width: 361, height: 38)
                .offset(y: -10)
                .background {
                    RoundedRectangle(cornerRadius: 20)
                        .trim(from: 0.5, to: 1)
                        .foregroundStyle(colors.statusColor)
                }
            
            BusStopDetailView(isEndStopViewVisible: true, stopNameKorean: busStopDetail.stopNameKorean ?? "", stopNameRomanized: busStopDetail.stopNameRomanized ?? "", stopNameNaver: busStopDetail.stopNameNaver ?? "")
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
                    .foregroundStyle(.brandBackground)
                }
                .offset(y: -19)
        }
    }
}
