//
//  APIRequest.swift
//  TMT
//
//  Created by Choi Minkyeong on 10/9/24.
//

import Foundation

struct BusInfo {
    var arrmsg1: String = ""
    var arrmsg2: String = ""
    var nextStId: String = ""
    var vehId: String = "" // 버스 위치 정보 API에서 제공하는 버스 고유 번호
    var vehId1: String = "" // 버스 도착 정보 API에서 제공하는 첫번째로 도착하는 버스 고유 번호
    var vehId2: String = "" // 버스 도착 정보 API에서 제공하는 두번째로 도착하는 버스 고유 번호
}

class APIRequest: ObservableObject {
    @Published var busInfo = BusInfo()
    
    private func fetchBusArrivalData(urlString: String) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Invalid response")
                return
            }

            if let data = data {
                print("Received Bus Arrival Data: \(String(data: data, encoding: .utf8) ?? "No Data")")
                let arrivalParser = BusInfoParser()
                arrivalParser.parseXML(data: data)

                DispatchQueue.main.async {
                    self.busInfo.arrmsg1 = arrivalParser.arrmsg1
                    self.busInfo.arrmsg2 = arrivalParser.arrmsg2
                    self.busInfo.vehId1 = arrivalParser.vehId1
                    self.busInfo.vehId2 = arrivalParser.vehId2
                }
            }
        }
        task.resume()
    }

    private func fetchBusLocationData(urlString: String) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Invalid response")
                return
            }

            if let data = data {
                print("Received Bus Location Data: \(String(data: data, encoding: .utf8) ?? "No Data")")
                let locationParser = BusInfoParser()
                locationParser.parseXML(data: data)

                DispatchQueue.main.async {
                    self.busInfo.vehId = locationParser.vehId
                    self.busInfo.nextStId = locationParser.nextStId
                }
            }
        }
        task.resume()
    }
    
    private func getAPIKey() -> String {
        guard let apiKey = Bundle.main.infoDictionary?["APIKey"] as? String else {
            fatalError("APIKey not found in Info.plist")
        }
        return apiKey
    }
    
    private func getArrivalInfoURL() -> String {
        let apiKey = getAPIKey()
        return "http://ws.bus.go.kr/api/rest/arrive/getArrInfoByRoute?ServiceKey=\(apiKey)&stId=122000048&busRouteId=100100075&ord=20"
    }
    
    private func getBusPositionURL() -> String {
        let apiKey = getAPIKey()
        return "http://ws.bus.go.kr/api/rest/buspos/getBusPosByRtid?ServiceKey=\(apiKey)&busRouteId=100100075"
    }
    
    /// 버스 도착 정보와 위치 정보 데이터를 불러옵니다.
    func fetchData() {
        let arrivalInfoURL = getArrivalInfoURL()
        let busPositionURL = getBusPositionURL()
        fetchBusArrivalData(urlString: arrivalInfoURL)
        fetchBusLocationData(urlString: busPositionURL)
    }
}
