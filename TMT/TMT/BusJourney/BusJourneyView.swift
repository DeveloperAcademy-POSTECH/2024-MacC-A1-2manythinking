//
//  BusJourneyView.swift
//  TMT
//
//  Created by 김유빈 on 10/8/24.
//

import SwiftUI

struct BusJourneyView: View {
    @StateObject private var apiRequest = APIRequest()
    
    private func getAPIKey() -> String {
        guard let apiKey = Bundle.main.infoDictionary?["APIKey"] as? String else {
            fatalError("APIKey not found in Info.plist")
        }
        return apiKey
    }
    
    // URL을 생성하는 메서드
    private func getArrivalInfoURL() -> String {
        let apiKey = getAPIKey()
        return "http://ws.bus.go.kr/api/rest/arrive/getArrInfoByRoute?ServiceKey=\(apiKey)&stId=122000048&busRouteId=100100075&ord=20"
    }
    
    private func getBusPositionURL() -> String {
        let apiKey = getAPIKey()
        return "http://ws.bus.go.kr/api/rest/buspos/getBusPosByRtid?ServiceKey=\(apiKey)&busRouteId=100100075"
    }
    
    var body: some View {
        VStack {
            if apiRequest.arrmsg1.isEmpty && apiRequest.arrmsg2.isEmpty && apiRequest.nextStId.isEmpty {
                Text("Loading data...")
                    .onAppear {
                        fetchData()
                    }
            } else {
                VStack {
                    Text("First Bus Arrival: \(apiRequest.arrmsg1)")
                    Text("Second Bus Arrival: \(apiRequest.arrmsg2)")
                    
                    Text("First Arrived Bus Number: \(apiRequest.vehId1)")
                    Text("Second Arrived Bus Number: \(apiRequest.vehId2)")
                    
                    Text("Real Bus Number: \(apiRequest.vehId)")
                    Text("Next stop List: \(apiRequest.nextStId)")
                }
                .padding()
                
            }
        }
    }
    private func fetchData() {
        let arrivalInfoURL = getArrivalInfoURL()
        let busPositionURL = getBusPositionURL()
        apiRequest.fetchBusArrivalData(urlString: arrivalInfoURL)
        apiRequest.fetchBusLocationData(urlString: busPositionURL)
    }
}
