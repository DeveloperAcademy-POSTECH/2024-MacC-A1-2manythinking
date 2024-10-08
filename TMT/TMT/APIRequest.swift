//
//  APIRequest.swift
//  TMT
//
//  Created by Choi Minkyeong on 10/9/24.
//

import Foundation

class APIRequest: ObservableObject {
    @Published var arrmsg1: String = ""
    @Published var arrmsg2: String = ""
    @Published var nextStId: String = ""
    @Published var vehId: String = ""
    @Published var vehId1: String = ""
    @Published var vehId2: String = ""

    func fetchBusArrivalData(urlString: String) {
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
                    self.arrmsg1 = arrivalParser.arrmsg1
                    self.arrmsg2 = arrivalParser.arrmsg2
                    self.vehId1 = arrivalParser.vehId1
                    self.vehId2 = arrivalParser.vehId2
                }
            }
        }
        task.resume()
    }

    func fetchBusLocationData(urlString: String) {
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
                    self.vehId = locationParser.vehId
                    self.nextStId = locationParser.nextStId
                }
            }
        }
        task.resume()
    }
}
