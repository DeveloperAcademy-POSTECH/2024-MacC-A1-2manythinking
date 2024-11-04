//
//  ScannedJourneyInfoView.swift
//  TMT
//
//  Created by Choi Minkyeong on 11/3/24.
//

import SwiftUI

struct ScannedJourneyInfoView: View {
    @Binding var scannedJourneyInfo: String
    @State private var busNumber: String = ""
    @State private var startStop: String = ""
    @State private var endStop: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            uploadedInfoBox(title: "Bus Number", scannedInfo: $busNumber)
                .padding(.bottom, 24)
            
            uploadedInfoBox(title: "Departure Stop", scannedInfo: $startStop)
                .padding(.bottom, 24)
            
            uploadedInfoBox(title: "Arrival Stop", scannedInfo: $endStop)
                .padding(.bottom, 20)
            
            // TODO: 유디 pr 머지되면 버튼 컴포넌트로 start 버튼 바꾸기
        }
        .padding(.horizontal, 16)
        .onAppear {
            splitScannedInfo()
        }
    }
    
    private func splitScannedInfo() {
        let splitted = scannedJourneyInfo.split(separator: ",")
        if splitted.count >= 3 {
            busNumber = String(splitted[0])
            startStop = String(splitted[1])
            endStop = String(splitted[2])
        }
    }
    
    private func uploadedInfoBox(title: String, scannedInfo: Binding<String>) -> some View {
        VStack(alignment: .leading) {
            Text("\(title)")
                .foregroundStyle(.gray)
            HStack {
                Text(scannedInfo.wrappedValue)
                    .bold()
                    .font(.title)
                Spacer()
                Button {
                    scannedInfo.wrappedValue = ""
                } label: {
                    Image(systemName: "xmark.circle")
                        .foregroundStyle(Color.gray)
                        .font(.title)
                }
            }
        }
    }
}

#Preview {
    ScannedJourneyInfoView(scannedJourneyInfo: .constant("207,BioTechnology,jukdo Market"))
}
