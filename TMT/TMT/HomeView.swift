//
//  ContentView.swift
//  TMT
//
//  Created by 김유빈 on 9/29/24.
//

import SwiftUI

struct HomeView: View {
    @State private var isShowingOnboarding = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                // TODO: 정보 입력 화면 넣기
                // TODO: 온보딩 확인하는 버튼 위치 추가하기

                Button {
                    isShowingOnboarding = true
                } label: {
                    Image(systemName: "exclamationmark.circle")
                        .resizable()
                        .frame(width: 24, height: 24)
                }
            }
            
            if isShowingOnboarding {
                OnboardingView(isShowingOnboarding: $isShowingOnboarding)
            }
        }
    }
}

#Preview {
    HomeView()
}
