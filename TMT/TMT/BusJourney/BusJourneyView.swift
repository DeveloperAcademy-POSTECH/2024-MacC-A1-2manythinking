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
            if apiRequest.busInfo.arrmsg1.isEmpty && apiRequest.busInfo.arrmsg2.isEmpty && apiRequest.busInfo.nextStId.isEmpty {
                Text("Loading data...")
                    .onAppear {
                        apiRequest.fetchData()
                    }
            } else {
                VStack {
                    Text("First Bus Arrival: \(apiRequest.busInfo.arrmsg1)")
                    Text("Second Bus Arrival: \(apiRequest.busInfo.arrmsg2)")
                    
                    Text("First Arrived Bus Number: \(apiRequest.busInfo.vehId1)")
                    Text("Second Arrived Bus Number: \(apiRequest.busInfo.vehId2)")
                    
                    Text("Real Bus Number: \(apiRequest.busInfo.vehId)")
                    Text("Next stop List: \(apiRequest.busInfo.nextStId)")
                }
                .padding()
                
            }
        }
    }
}
