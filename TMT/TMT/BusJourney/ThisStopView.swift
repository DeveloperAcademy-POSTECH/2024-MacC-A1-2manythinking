//
//  ThisStopView.swift
//  TMT
//
//  Created by Choi Minkyeong on 10/31/24.
//

import SwiftUI

struct ThisStopView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var stopNameKorean: String
    var stopNameNaver: String
    var stopNameRomanized: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("KOR")
                .frame(width: 52, height: 21)
                .background(Color.yellow)
                .cornerRadius(4)
            Text("\(stopNameRomanized)")
                .font(.title)
                .bold()
            Text("\(stopNameKorean)")
                .padding(.bottom, 18)
            Text("ENG")
                .frame(width: 52, height: 21)
                .background(Color.yellow)
                .cornerRadius(4)
            Text("\(stopNameNaver)")
                .padding(.bottom, 16)
        }
        .frame(width: 393)
        .padding()
        
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
            self.presentationMode.wrappedValue.dismiss()
        } label: {
            Image(systemName: "chevron.left")
                .foregroundStyle(.black)
            
        }
    }
}

#Preview {
    ThisStopView(stopNameKorean: "포항제철고등학교", stopNameNaver: "Pohang Jecheol High School", stopNameRomanized: "Pohang Je-cheol Go-deung-hak-gyo")
}
