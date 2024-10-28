//
//  BusSearchViewModel.swift
//  TMT
//
//  Created by 김유빈 on 10/15/24.
//

import Foundation
import MapKit

final class BusStopSearchViewModel: ObservableObject {
    @Published var busStops: [BusStopInfo] = []
    @Published var filteredBusStops: [BusStopInfo] = []
    @Published var busNumbers = [Int]()
    @Published var remainingStops: Int = 0
    
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
        fetchBusNumbersList()
    }
    
    /// 검색 결과 배열에는 노선 전체 데이터가 담겨 있어 동일한 버스 번호를 가진 데이터가 많습니다.
    /// 사용자에게 보여줄 때는 중복된 데이터를 제외하고, 버스 번호만 추출해서 보여줘야 합니다.
    /// 사용자가 검색한 버스 번호를 추출하여 결과로 보여주기 위해 버스 번호만 추출하기 위해 만든 함수입니다.
    private func fetchBusNumbersList() {
        busNumbers = Array(Set(filteredBusStops.compactMap { busStop in
            if let busNumberString = busStop.busNumber, let busNumber = Int(busNumberString) {
                return busNumber
            }
            return nil
        }))
    }
    
    /// 사용자 입력에 따라 출발 정류장과 하차 정류장 설정
    func setJourneyStops(startStop: BusStopInfo, endStop: BusStopInfo) {
        self.startStop = startStop
        self.endStop = endStop
    }
    
    /// 실시간으로 남은 정류장 수 업데이트
    func updateRemainingStops(currentLocation: CLLocationCoordinate2D) {
        guard let startStop = self.startStop, let endStop = self.endStop else {
            print("출발 정류장과 하차 정류장을 설정하세요..")
            return
        }
        
        guard let startIndex = startStop.stopOrder,
              let endIndex = endStop.stopOrder,
              startIndex <= endIndex else {
            print("출발 정류장과 하차 정류장 순서가 올바르지 않습니다.")
            return
        }
                
        let journeyStops = busStops.filter { stop in
            guard let order = stop.stopOrder else { return false }
            return startStop.busNumber == stop.busNumber && order >= startIndex && order <= endIndex
        }
        
        var passedStops = 0
        
        for stop in journeyStops {
            guard let stopLatitude = stop.latitude, let stopLongitude = stop.longitude else { continue }
            
            let stopLocation = CLLocation(latitude: stopLatitude, longitude: stopLongitude)
            let userLocation = CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
            
            if userLocation.distance(from: stopLocation) < 50.0 {
                passedStops += 1
            }
        }
        
        self.remainingStops = max(0, journeyStops.count - passedStops - 1)
    }
}
