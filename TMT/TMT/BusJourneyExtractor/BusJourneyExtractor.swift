//
//  BusJourneyExtractor.swift
//  TMT
//
//  Created by Choi Minkyeong on 10/24/24.
//

import Foundation

class BusJourneyExtractor {
    static func analyzeText(_ recognizedString: String) -> String? {
        var sortOfBuses: [String] = []
        var sortOfBusNumber: [String] = []
        var slicedArray: [String] = []
        
        var busStopToBoard: String = ""
        var busNumber: String = ""
        var busStopToGetOff: String = ""
        
        // 환승 노선 정보
        var busStopToBoard2: String = ""
        var busNumber2: String = ""
        var busStopToGetOff2: String = ""
        var busStopToBoard3: String = ""
        var busNumber3: String = ""
        var busStopToGetOff3: String = ""
        
        let busColors = ["Blue", "General", "Express", "Green", "Town"]
        let busNumbers = ["206", "207", "209", "216", "302", "305", "306", "308", "600", "700", "800", "900"]
        let arrivalInfoWords = ["min", "stops", "Interval:", "Weekdays", "Total", "buses", "Everyday", "Weekends", "No", "ETA"]
        
        let stringInArray = recognizedString.components(separatedBy: CharacterSet.whitespacesAndNewlines)
        
        // 실제 사용자가 이용할 경로에 대한 문자열만 남깁니다.
        if let secondMinIndex = stringInArray.enumerated().filter({ $0.element.contains("min") }).dropFirst().first?.offset,
           let goIndex = stringInArray.firstIndex(of: "GO") {
            if secondMinIndex < goIndex {
                slicedArray = Array(stringInArray[secondMinIndex...goIndex])
            } else {
                print("두 번째 'min'이 'Go'보다 뒤에 있습니다.")
                guard let secondGoIndex = stringInArray.enumerated().filter({ $0.element == "GO" }).dropFirst().first?.offset else { return nil }
                if secondMinIndex < secondGoIndex {
                    slicedArray = Array(stringInArray[secondMinIndex...secondGoIndex])
                }
            }
        } else {
            print("Slicing failed.")
        }
        
        // OCR 문제를 막기 위해 경로에서 분 정보를 제거합니다. ex) 3m, 12m
        let filteredArray = slicedArray.filter { !$0.matches("[0-9]+m") && $0 != "Best" && $0 != "route" }
        
        // 어떤 종류의 버스를 타는지 구합니다. 예시: ["blue", "blue", "general"]
        sortOfBuses = filteredArray.filter { busColors.contains($0) }
        print("sortOfBuses: \(sortOfBuses)")
        
        // 지금 가는 경로가 여러대의 버스를 포함하고 있는지 확인합니다. 예시: ["306", "306", "207"]
        sortOfBusNumber = filteredArray.filter { element in
            busNumbers.contains { element.contains($0) }
        }
        print("sortOfBusNumber: \(sortOfBusNumber)")
        
        // 버스 경로 생김새에 따라 분기처리합니다.
        if let firstColorIndex = filteredArray.firstIndex(where: { element in
            sortOfBuses.contains(where: { busType in element.contains(busType) })
        }), firstColorIndex + 2 < filteredArray.count {
            let twoStepsAfterIndex = firstColorIndex + 2
            if sortOfBuses.contains(where: { filteredArray[twoStepsAfterIndex].contains($0) }) {
                // 세로로 OCR 처리가 된 경우
                print("세로로 OCR 처리가 된 경우")
                if sortOfBuses.count < 2 {
                    // 환승 아닌 노선
                    print("환승 아닌 노선")
                    if sortOfBusNumber.count < 2 {
                        // 버스 한대만 감.
                        print("버스 한대만 감")
                    } else {
                        // 버스 여러대 감.
                        print("버스 여러대 감")
                    }
                
                } else {
                    // 환승 노선
                    // TODO: 환승 노선은 다음 이터레이션에 구현될 예정입니다.
                    // TODO: 현재 첫번째 노선에 대한 탑승 버스정류장과 탑승할 버스 번호를 받는 로직만 구현되어있습니다.
                    
                    // TODO: 환승 노선을 게시할 경우 다시 올려달라는 에러창을 띄웁니다.🚨🚨
                    print("환승 노선")
                    var currentIndex: Int = 0
                    
                    // 첫번째 노선 탑승할 정류장 정보
                    if let firstIndex = filteredArray.firstIndex(of: "off"),
                       let secondIndex = filteredArray.firstIndex(of: sortOfBusNumber[0]),
                       firstIndex < secondIndex {
                        let result = filteredArray[(firstIndex + 1)..<secondIndex].dropLast()
                        currentIndex = secondIndex
                        for results in result {
                            busStopToBoard += results + " "
                        }
                        print("busStopToBoard: \(busStopToBoard)")
                    } else {
                        print("'off'와 '306(기본)' 사이의 값을 찾을 수 없습니다.")
                    }
                    
                    // 첫번째 노선 탑승할 버스 번호 정보
                    var endIndex = currentIndex
                    while endIndex < filteredArray.count, let _ = sortOfBusNumber.first(where: { filteredArray[endIndex].contains($0) }) {
                        endIndex += 1
                    }
                    let result = Array(filteredArray[currentIndex..<endIndex])
                    busNumber = stringArrayToStirng(stringArray: result)
                }
            } else {
                // 가로로 OCR 처리가 된 경우
                print("가로로 OCR 처리가 된 경우")
                if sortOfBuses.count < 2 {
                    // 환승 아닌 노선
                    print("환승 아닌 노선")
                    if sortOfBusNumber.count < 2 {
                        // 버스 한대만 감.
                        print("버스 한대만 감")
                        
                        // 버스 번호를 구합니다.
                        if !sortOfBusNumber[0].isEmpty {
                            busNumber = sortOfBusNumber.first ?? ""
                        } else {
                            print("No bus info.")
                        }
                        
                        // 탑승 정류장을 구합니다.
                        if let firstIndex = filteredArray.firstIndex(of: sortOfBuses[0]),
                           let secondIndex = filteredArray.firstIndex(where: { $0 == "ETA" || $0 == busNumber }),
                           firstIndex < secondIndex {
                            let result = Array(filteredArray[(firstIndex + 1)..<(secondIndex)].dropLast())
                            busStopToBoard = stringArrayToStirng(stringArray: result)
                        } else {
                            print("Failed to extract busStopBoard.")
                        }
                        
                        // 하차 정류장을 구합니다.
                        if let firstIndex = filteredArray.firstIndex(of: "off"),
                           let secondIndex = filteredArray.firstIndex(of: "GO"),
                           firstIndex < secondIndex {
                            let result = Array(filteredArray[(firstIndex + 1)..<secondIndex].dropLast())
                            busStopToGetOff = stringArrayToStirng(stringArray: result)
                        } else {
                            print("Failed to extract busStopToGetOff.")
                        }
                    } else {
                        // 버스 여러대 감.
                        print("버스 여러대 감")
                        
                    }
                } else {
                    // 환승노선
                    // TODO: 환승 노선은 다음 이터레이션에 구현될 예정입니다.
                    print("환승노선")
                }
            }
        }
    
        return busStopToBoard + "," + busNumber + "," + busStopToGetOff
    }
    
    static func stringArrayToStirng(stringArray: [String]) -> String {
        var string: String = ""
        if !stringArray.isEmpty {
            for results in stringArray {
                string += results + " "
            }
            return string
        } else {
            print("String array is empty.")
            return ""
        }
    }
}
    
extension String {
    func matches(_ pattern: String) -> Bool {
        return self.range(of: pattern, options: .regularExpression) != nil
    }
}
