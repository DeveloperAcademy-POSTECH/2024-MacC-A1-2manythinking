//
//  NextStopInfoView.swift
//  TMT
//
//  Created by Choi Minkyeong on 10/19/24.
//

import SwiftUI

// TODO: 색, 폰트 사이즈, padding 확정되면 다시 수정하기
struct NextStopInfoView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .foregroundStyle(.black)
            VStack {
                Spacer().frame(height: 20)
                HStack {
                    Spacer().frame(width: 19)
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundStyle(.purple)
                            .frame(width: 104, height: 32)
                        HStack {
                            Text("3")
                                .font(.title3)
                                .bold()
                            Text("left")
                                .font(.subheadline)
                        }
                    }
                    Spacer()
                }
                HStack {
                    Spacer().frame(width: 19)
                    Text("Postech")
                        .font(.largeTitle)
                        .bold()
                    Spacer()
                }
                HStack {
                    Spacer().frame(width: 19)
                    Text("포스텍")
                        .font(.subheadline)
                    Spacer()
                }
                Spacer()
            }
            Spacer()
        }
        .frame(width: 361, height: 195)
        .foregroundStyle(.white)
    }
}

#Preview {
    NextStopInfoView()
}
