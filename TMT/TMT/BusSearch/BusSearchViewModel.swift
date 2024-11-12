//
//  BusSearchViewModel.swift
//  TMT
//
//  Created by 김유빈 on 10/15/24.
//

import Foundation
import MapKit

final class BusSearchViewModel: ObservableObject {
    @Published var allBusData: [BusStop] = []
    @Published var filteredBusDataForNumber: [BusStop] = []
    
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
            self.allBusData.append(BusStop(busNumber: response[0].isEmpty ? nil : response[0],
                                             busType: response[1].isEmpty ? nil : Int(response[1]),
                                             stopOrder: response[2].isEmpty ? nil : Int(response[2]),
                                             stopNameKorean: response[3].isEmpty ? nil : response[3],
                                             stopNameRomanized: response[4].isEmpty ? nil : response[4],
                                             stopNameNaver: response[5].isEmpty ? nil : response[5],
                                             latitude: response[6].isEmpty ? nil : Double(response[6]),
                                             longitude: response[7].isEmpty ? nil : Double(response[7].dropLast(1))))
        }
    }
    
    // MARK: 버스 데이터 검색 (버스 번호, 정류장 이름)
    func searchBusStops(byNumber number: String) {
        filteredBusDataForNumber = allBusData.filter { busStop in
            if let busNumber = busStop.busNumber {
                return busNumber.contains(number)
            }
            return false
        }
    }

    func searchBusStops(byName name: String) -> [BusStop] {
        return filteredBusDataForNumber.filter {
            name.contains($0.stopNameNaver ?? "") || name.contains($0.stopNameKorean ?? "")
        }
    }
}
