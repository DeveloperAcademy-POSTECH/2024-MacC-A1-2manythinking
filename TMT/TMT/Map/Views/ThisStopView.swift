//
//  ThisStopView.swift
//  TMT
//
//  Created by Choi Minkyeong on 10/31/24.
//

import SwiftUI

struct ThisStopView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var activityManager: LiveActivityManager
    @State private var showingAlert = false
    
    var stopNameKorean: String
    var stopNameNaver: String
    var stopNameRomanized: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("KOR")
                .foregroundStyle(Color.Basic.yellow800)
                .frame(width: 52, height: 21)
                .background(Color.Basic.yellow300)
                .cornerRadius(4)
            Text("\(stopNameRomanized)")
                .font(.title)
                .bold()
            Text("\(stopNameKorean)")
                .padding(.bottom, 18)
            if !stopNameNaver.isEmpty {
                Text("ENG")
                    .foregroundStyle(Color.Basic.yellow800)
                    .frame(width: 52, height: 21)
                    .background(Color.Basic.yellow300)
                    .cornerRadius(4)
                Text("\(stopNameNaver)")
                    .padding(.bottom, 16)
            }
        }
        .padding(.top, 8)
        .padding(.horizontal, 16)
        .frame(width: 393, alignment: .leading)
        
        // TODO: 블러처리와 흰 화면을 동시에 쌓을 수 있는 방법 찾기
        .background (
            Rectangle()
                .fill(.ultraThinMaterial)
                .edgesIgnoringSafeArea(.top)
                .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 2)
        )
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
        .navigationTitle("This Stop")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var backButton: some View {
        Button {
            showingAlert = true
        } label: {
            Image(systemName: "chevron.left")
                .foregroundStyle(.black)
        }
        .alert("End Navigation", isPresented: $showingAlert) {
            Button {
                showingAlert = false
            } label: {
                Text("Stay")
                    .foregroundStyle(.blue)
            }
            Button {
                self.presentationMode.wrappedValue.dismiss()
                activityManager.endLiveActivity()
            } label: {
                Text("Exit")
                    .foregroundStyle(.blue)
                    .fontWeight(.bold)
            }
        } message: {
            Text("Are you sure you want to return to Home? Your navigation will end.")
        }
    }
}

#Preview {
    ThisStopView(
        stopNameKorean: "영일대 해수욕장",
        stopNameNaver: "Yeongildae Beach",
        stopNameRomanized: "Yeong-il-dae Hae-su-yok-jang"
    )
    .environmentObject(LiveActivityManager()) // LiveActivityManager 환경 객체 추가
}

