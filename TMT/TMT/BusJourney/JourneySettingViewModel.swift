//
//  JourneySettingViewModel.swift
//  TMT
//
//  Created by 김유빈 on 11/11/24.
//

import Foundation
import MapKit

final class JourneySettingViewModel: ObservableObject {
    @Published var journeyStops: [BusStop] = []
    
    private var startStop: BusStop?
    private var endStop: BusStop?
    
    private let searchModel: BusSearchViewModel
    
    init(searchModel: BusSearchViewModel) {
        self.searchModel = searchModel
    }
    
    // MARK: 출발 및 하차 정류장 설정
    func setJourneyStops(busNumberString: String, startStopString: String, endStopString: String) {
        searchModel.searchBusStops(byNumber: busNumberString)
        
        let startCandidates = searchModel.searchBusStops(byName: startStopString)
        let endCandidates = searchModel.searchBusStops(byName: endStopString)

        findJourneyStopsSequence(from: startCandidates, to: endCandidates)
    }

    // MARK: 출뱔 정류장부터 하차 정류장까지 배열 찾기
    func findJourneyStopsSequence(from startCandidates: [BusStop], to endCandidates: [BusStop]) {
        if let validStops = findValidStartAndEndStops(from: startCandidates, to: endCandidates) {
            self.startStop = validStops.startStop
            self.endStop = validStops.endStop
            
            if let startOrder = validStops.startStop.stopOrder, let endOrder = validStops.endStop.stopOrder {
                let filteredStops = searchModel.allBusData.filter {
                    guard let order = $0.stopOrder else { return false }
                    return $0.busNumber == startStop?.busNumber && order >= startOrder && order <= endOrder
                }
                self.journeyStops = filteredStops
            }
        }
    }
    
    private func findValidStartAndEndStops(from startCandidates: [BusStop], to endCandidates: [BusStop]) -> (startStop: BusStop, endStop: BusStop)? {
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
                
        return max(0, journeyStops.count - passedStops - 1)
    }

}
