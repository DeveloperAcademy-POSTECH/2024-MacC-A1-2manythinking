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
    @State private var backToHome: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            uploadedInfoBox(title: "Bus Number", scannedInfo: $busNumber)
            uploadedInfoBox(title: "Departure Stop", scannedInfo: $startStop)
            uploadedInfoBox(title: "Arrival Stop", scannedInfo: $endStop)
            
            HStack {
                Button {
                    scannedJourneyInfo = ""
                    backToHome = true
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.yellow, lineWidth: 1)
                        
                        Text("Reupload")
                            .foregroundStyle(.yellow)
                    }
                    .padding(.trailing, 8)
                }
                
                Button {
                    // Go to Map
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.yellow)
                            .stroke(.yellow)
                        Text("Start")
                            .foregroundStyle(.black)
                    }
                }
            }
            .frame(height: 52)
            .padding(.vertical, 12.5)
            
            if backToHome {
                UploadPhotoView()
            }
        }
        .onAppear {
            splitScannedInfo()
        }
    }
    
    private func splitScannedInfo() {
        let splitted = scannedJourneyInfo.split(separator: ",")
        if splitted.count >= 3 {
            busNumber = String(splitted[1])
            startStop = String(splitted[0])
            endStop = String(splitted[2])
        }
    }
    
    private func uploadedInfoBox(title: String, scannedInfo: Binding<String>) -> some View {
        VStack(alignment: .leading) {
            Text("\(title)")
                .foregroundStyle(.gray)
            TextField("\(scannedInfo.wrappedValue)", text: scannedInfo)
                .bold()
                .font(.title)
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .center)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(.gray, lineWidth: 1)
                        .background(Color.white.cornerRadius(8)) // 배경 색상 설정
                )
                .keyboardType(title == "Bus Number" ? .numberPad : .default)
        }
        .padding(.bottom, 16)
    }
}

#Preview {
    ScannedJourneyInfoView(scannedJourneyInfo: .constant("207,BioTechnology,jukdo Market"))
}
