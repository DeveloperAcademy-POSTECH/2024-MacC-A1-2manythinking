//
//  BusSearchViewModel.swift
//  TMT
//
//  Created by 김유빈 on 10/15/24.
//

import Foundation

final class BusStopSearchViewModel: ObservableObject {
    @Published var busStops: [BusStopInfo] = []
    @Published var filteredBusStops: [BusStopInfo] = []
    
    init() {
        loadCSV()
    }
    
    private func loadCSV() {
        Task {
            guard let filepath = Bundle.main.path(forResource: "BusStopData", ofType: "csv") else {
                print("Error \(#function) in \(#file) :: CSV file not found")
                return
            }
            do {
                let content = try String(contentsOfFile: filepath)
                
                let response = content.components(separatedBy: "\n")
                
                let searchResponse = response.map { $0.components(separatedBy: ",")}
                
                await self.apply(searchResponse)
                
            } catch {
                print("Error \(#function) in \(#file)")
            }
        }
    }
    
    @MainActor
    private func apply(_ searchResponse: [[String]]) {
        for response in searchResponse {
            self.busStops.append(BusStopInfo(busNumber: response[0].isEmpty ? nil : response[0],
                                             busType: response[1].isEmpty ? nil : Int(response[1]),
                                             stopOrder: response[2].isEmpty ? nil : Int(response[2]),
                                             stopName: response[3].isEmpty ? nil : response[3],
                                             romanizedStopName: response[4].isEmpty ? nil : response[4],
                                             xCoordinate: response[5].isEmpty ? nil : response[5],
                                             yCoordinate: response[6].isEmpty ? nil : String(response[6].dropLast(1))))
        }
    }
    
    func searchBusStops(by number: String) {
        filteredBusStops = busStops.filter { busStop in
            if let busNumber = busStop.busNumber {
                return busNumber.hasPrefix(number)
            }
            return false
        }
    }
}
