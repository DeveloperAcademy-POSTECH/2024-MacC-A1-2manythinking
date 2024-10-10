//
//  BusJourneyView.swift
//  TMT
//
//  Created by 김유빈 on 10/8/24.
//

import SwiftUI

struct BusJourneyView: View {
    @StateObject private var apiRequest = APIRequest()
    
    var body: some View {
        VStack {
            if apiRequest.busInfo.arrmsg1.isEmpty && apiRequest.busInfo.arrmsg2.isEmpty && apiRequest.busInfo.stId.isEmpty {
                Text("Loading data...")
                    .onAppear {
                        apiRequest.fetchArrivalData()
                    }
            } else {
                VStack {
                    Text("First Bus Arrival: \(apiRequest.busInfo.arrmsg1)")
                    Text("Second Bus Arrival: \(apiRequest.busInfo.arrmsg2)")
                    
                    Text("First Arrived Bus Number: \(apiRequest.busInfo.vehId1)")
                    Text("Second Arrived Bus Number: \(apiRequest.busInfo.vehId2)")
                    
                    // TODO: 이후 엑셀 파일 연결되면 ord로 몇 정거장 남았는지 구하기.
                    Button {
                        apiRequest.fetchPositionData()
                    } label: {
                        Text("What is the next stop: \(apiRequest.busInfo.stId)")
                    }
                }
                .padding()
                
            }
        }
    }
}
