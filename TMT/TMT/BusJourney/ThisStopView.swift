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
        .background(Color.white)
        .opacity(0.7)
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
