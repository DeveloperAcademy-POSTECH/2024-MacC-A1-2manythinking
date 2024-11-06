//
//  BusSearchViewModel.swift
//  TMT
//
//  Created by 김유빈 on 10/15/24.
//

import Foundation
import MapKit

final class BusSearchViewModel: ObservableObject {
    @Published var busStops: [BusStopInfo] = []
    @Published var filteredBusStops: [BusStopInfo] = []
    @Published var remainingStops: Int = 0
    @Published var journeyStops: [BusStopInfo] = []
    
    private var startStop: BusStopInfo?
    private var endStop: BusStopInfo?

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
                                             stopNameKorean: response[3].isEmpty ? nil : response[3],
                                             stopNameRomanized: response[4].isEmpty ? nil : response[4],
                                             stopNameNaver: response[5].isEmpty ? nil : response[5],
                                             latitude: response[6].isEmpty ? nil : Double(response[6]),
                                             longitude: response[7].isEmpty ? nil : Double(response[7].dropLast(1))))
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
    
    func setJourneyStops(startStopString: String, endStopString: String) {
        let startCandidates = searchBusStops(for: startStopString)
        let endCandidates = searchBusStops(for: endStopString)
        
        if let validStops = findValidJourneyStops(from: startCandidates, to: endCandidates) {
            self.startStop = validStops.startStop
            self.endStop = validStops.endStop

            if let startOrder = validStops.startStop.stopOrder, let endOrder = validStops.endStop.stopOrder {
                let filteredStops = busStops.filter {
                    guard let order = $0.stopOrder else { return false }
                    return $0.busNumber == startStop?.busNumber && order >= startOrder && order <= endOrder
                }
                
                self.journeyStops = filteredStops
            }
        }
        
        print(journeyStops)
    }
    
    private func searchBusStops(for busStopName: String) -> [BusStopInfo] {
        return busStops.filter{ $0.stopNameKorean == busStopName }
    }
    
    private func findValidJourneyStops(from startCandidates: [BusStopInfo], to endCandidates: [BusStopInfo]) -> (startStop: BusStopInfo, endStop: BusStopInfo)? {
        let startOrders = startCandidates.compactMap { $0.stopOrder }
        let endOrders = endCandidates.compactMap { $0.stopOrder }
        
        guard let startMin = startOrders.min(), let endMin = endOrders.min(),
              let startMax = startOrders.max(), let endMax = endOrders.max() else { return nil }
        
        if startMin < endMin {
            if let startInfo = startCandidates.first(where: { $0.stopOrder == startMin }),
               let endInfo = endCandidates.first(where: { $0.stopOrder == endMin }) {
                return (startInfo, endInfo)
            }
        } else {
            if let startInfo = startCandidates.first(where: { $0.stopOrder == startMax }),
               let endInfo = endCandidates.first(where: { $0.stopOrder == endMax }) {
                return (startInfo, endInfo)
            }
        }
        
        return nil
    }
    
    /// 실시간으로 남은 정류장 수 업데이트
    func updateRemainingStops(currentLocation: CLLocationCoordinate2D) -> Int {
        guard !journeyStops.isEmpty else {
            print("정류장 설정 plz ..")
            return 0
        }
        
        var passedStops = 0
        
        for (index, stop) in journeyStops.enumerated() {
            guard let stopLatitude = stop.latitude, let stopLongitude = stop.longitude else { continue }
            
            let stopLocation = CLLocation(latitude: stopLatitude, longitude: stopLongitude)
            let userLocation = CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
            
            if userLocation.distance(from: stopLocation) < 50.0 {
                passedStops = index
                break
            }
        }
        
        self.remainingStops = max(0, journeyStops.count - passedStops - 1)
        return self.remainingStops
    }
}
