//
//  BusJourneyExtractor.swift
//  TMT
//
//  Created by Choi Minkyeong on 10/24/24.
//

import Foundation

class BusJourneyExtractor {
    /// OCR로 읽은 정보 중 필요한 정보만 뽑아냅니다.
    static func analyzeText(_ recognizedString: String) -> String? {
        var sortOfBuses: [String] = []
        var sortOfBusNumber: [String] = []
        var extractedInfo: (startStop: String, busNumber: String, endStop: String) = ("", "", "")
        
        var stringInArray = recognizedString.components(separatedBy: CharacterSet.whitespacesAndNewlines)
        let firstMinIndex = stringInArray.enumerated().filter({ $0.element.contains("min") }).first?.offset ?? 0
        stringInArray.remove(at: firstMinIndex)
        
        let slicedArray = extractBusJourney(stringInArray: stringInArray)
        
        // OCR 문제를 막기 위해 경로에서 분 정보를 제거합니다. ex) 3m, 12m
        let filteredArray = slicedArray.filter { !$0.matches("\\b\\d+m\\b(?!in)") && $0 != "Best" && $0 != "route" }
        
        // 어떤 종류의 버스를 타는지 구합니다. 예시: ["blue", "blue", "general"]
        sortOfBuses = filteredArray.filter { BusColor.allColors.contains($0) }
        
        // 지금 가는 경로가 여러대의 버스를 포함하고 있는지 확인합니다. 예시: ["306", "306", "207"]
        sortOfBusNumber = filteredArray.filter { element in
            BusNumber.allNumbers.contains { element.contains($0) }
        }
        
        // MARK: - 버스 경로 생김새에 따라 분기처리합니다.
        if let firstColorIndex = filteredArray.firstIndex(where: { element in
            sortOfBuses.contains(where: { busType in element.contains(busType) })
        }), firstColorIndex + 2 < filteredArray.count {
            let twoStepsAfterIndex = firstColorIndex + 2
            if filteredArray[twoStepsAfterIndex] == "Get" {
                // 세로로 OCR 처리가 된 경우
                if sortOfBuses.count < 2 {
                    // 환승 아닌 노선
                    if sortOfBusNumber.count < 2 {
                        // 버스 한대만 감.
                        extractedInfo = VerticalOCROneLineType(filteredArray: filteredArray, sortOfBusNumber: sortOfBusNumber, arrivalWordsBack: ArrivalWordsBack.allBackWords)
                    } else {
                        // 버스 여러대 감.
                        extractedInfo = VerticalOCRMultipleLineType(filteredArray: filteredArray, sortOfBusNumber: sortOfBusNumber, arrivalWordsBack: ArrivalWordsBack.allBackWords)
                    }
                } else {
                    // 환승 노선
                    // TODO: 환승 노선은 다음 이터레이션에 구현될 예정입니다.
                }
            } else {
                // 가로로 OCR 처리가 된 경우
                if sortOfBuses.count < 2 {
                    // 환승 아닌 노선
                    if sortOfBusNumber.count < 2 {
                        // 버스 한대만 감.
                        extractedInfo = HorizontalOCROneLineType(filteredArray: filteredArray, sortOfBuses: sortOfBusNumber, sortOfBusNumber: ArrivalWordsBack.allBackWords)
                    } else {
                        // 버스 여러대 감
                        extractedInfo = HorizontalOCRMultipleLineType(filteredArray: filteredArray, sortOfBuses: sortOfBusNumber, sortOfBusNumber: ArrivalWordsBack.allBackWords)
                    }
                } else {
                    // 환승노선
                    // TODO: 환승 노선은 다음 이터레이션에 구현될 예정입니다.
                }
            }
        }
        
        if extractedInfo.startStop.isEmpty || extractedInfo.busNumber.isEmpty || extractedInfo.endStop.isEmpty {
            return ""
        } else {
            return extractedInfo.startStop + "," + extractedInfo.busNumber + "," + extractedInfo.endStop
        }
    }
    
    /// 사용자가 실제로 이용할 루트만 문자열에 남깁니다.
    private static func extractBusJourney(stringInArray: [String]) -> [String] {
        var slicedArray: [String] = []
        var currentMinIndex = 0
        while slicedArray.count < 15 {
            if let nextMinIndex = stringInArray.enumerated()
                .dropFirst(currentMinIndex)
                .filter({ $0.element.contains("min") })
                .first?.offset,
               let goIndex = stringInArray.firstIndex(of: "GO") {
                if nextMinIndex < goIndex {
                    slicedArray = Array(stringInArray[nextMinIndex...goIndex])
                    currentMinIndex = nextMinIndex + 1
                } else {
                    guard let secondGoIndex = stringInArray.enumerated()
                        .dropFirst(currentMinIndex)
                        .filter({ $0.element == "GO" })
                        .dropFirst()
                        .first?.offset else { break }
                    
                    if nextMinIndex < secondGoIndex {
                        slicedArray = Array(stringInArray[nextMinIndex...secondGoIndex])
                        currentMinIndex = nextMinIndex + 1
                    }
                }
            } else {
                break
            }
        }
        return slicedArray
    }
    
    /// OCR이 세로로 읽히고, 버스 경로에 하나의 버스만 존재하며, 환승이 없는 경우
    private static func VerticalOCROneLineType(filteredArray: [String], sortOfBusNumber: [String], arrivalWordsBack: [String]) -> (String, String, String) {
        var startStop: String = ""
        var busNumber: String = ""
        var endStop: String = ""
        
        if !sortOfBusNumber[0].isEmpty {
            busNumber = sortOfBusNumber.first ?? ""
        } else {
            print("No bus info.")
        }
        
        if let firstIndex = filteredArray.firstIndex(where: { $0 == "off" || $0 == "oft" || $0 == "otf" || $0 == "ott"}),
           let secondIndex = filteredArray.firstIndex(of: busNumber),
           firstIndex < secondIndex {
            let result = Array(filteredArray[(firstIndex + 1)..<secondIndex].dropLast())
            startStop = stringArrayToStirng(stringArray: result)
        } else {
            print("Failed to extract busStopBoard.")
        }
        
        if let secondIndex = filteredArray.firstIndex(of: "GO") {
            var firstIndex: Int = 0
            if let matchingIndex = filteredArray.firstIndex(where: { element in
                arrivalWordsBack.contains(where: { word in element.contains(word) })
            }) {
                firstIndex = matchingIndex
            } else {
                print("No matching element found.")
            }
            if firstIndex < secondIndex {
                let result = Array(filteredArray[(firstIndex + 1)..<secondIndex].dropLast())
                endStop = stringArrayToStirng(stringArray: result)
            }
        } else {
            print("Failed to extract busStopToGetOff.")
        }
        
        return (startStop, busNumber, endStop)
    }
    
    /// OCR이 세로로 읽히고, 버스 경로에 여러개의 버스가 존재하며, 환승이 없는 경우
    private static func VerticalOCRMultipleLineType(filteredArray: [String], sortOfBusNumber: [String], arrivalWordsBack: [String]) -> (String, String, String) {
        var startStop: String = ""
        var busNumber: String = ""
        var endStop: String = ""
        
        if !sortOfBusNumber[0].isEmpty {
            busNumber = sortOfBusNumber.first ?? ""
        } else {
            print("No bus info.")
        }
        
        // 탑승 정류장을 구합니다.
        if let firstIndex = filteredArray.firstIndex(where: { $0 == "off" || $0 == "oft" || $0 == "otf" || $0 == "ott"}),
           let secondIndex = filteredArray.firstIndex(of: busNumber),
           firstIndex < secondIndex {
            let result = Array(filteredArray[(firstIndex + 1)...secondIndex].dropLast())
            startStop = stringArrayToStirng(stringArray: result)
        } else {
            print("Failed to extract busStopBoard.")
        }
        
        if let secondIndex = filteredArray.firstIndex(of: "GO") {
            var foundIndices: [Int] = []
            for (index, word) in filteredArray.enumerated() {
                if arrivalWordsBack.contains(word) {
                    foundIndices.append(index)
                }
            }
            if foundIndices.count >= 2 {
                var result = Array(filteredArray[(foundIndices[1] + 1)..<secondIndex].dropLast())
                result = result.filter { $0 != "ETA" }
                endStop = stringArrayToStirng(stringArray: result)
            }
        } else {
            print("Failed to extract busStopToGetOff.")
        }
        
        busNumber = busNumber.filter { $0.isNumber }
        return (startStop, busNumber, endStop)
    }
    
    /// OCR이 가로로 읽히고, 버스 경로에 하나의 버스만 존재하며, 환승이 없는 경우
    private static func HorizontalOCROneLineType(filteredArray: [String], sortOfBuses: [String], sortOfBusNumber: [String]) -> (String, String, String) {
        var startStop: String = ""
        var busNumber: String = ""
        var endStop: String = ""
        
        if !sortOfBusNumber[0].isEmpty {
            busNumber = sortOfBusNumber.first ?? ""
        } else {
            print("No bus info.")
        }
        
        if let firstIndex = filteredArray.firstIndex(of: sortOfBuses[0]),
           let secondIndex = filteredArray.firstIndex(where: { $0 == "ETA" || $0 == busNumber }),
           firstIndex < secondIndex {
            let result = Array(filteredArray[(firstIndex + 1)..<secondIndex].dropLast())
            startStop = stringArrayToStirng(stringArray: result)
        } else {
            print("Failed to extract busStopBoard.")
        }
        
        if let firstIndex = filteredArray.firstIndex(where: { $0 == "off" || $0 == "oft" || $0 == "otf" || $0 == "ott"}),
           let secondIndex = filteredArray.firstIndex(of: "GO"),
           firstIndex < secondIndex {
            let result = Array(filteredArray[(firstIndex + 1)..<secondIndex].dropLast())
            endStop = stringArrayToStirng(stringArray: result)
        } else {
            print("Failed to extract busStopToGetOff.")
        }
        return (startStop, busNumber, endStop)
    }
    
    /// OCR이 가로로 읽히고, 버스 경로에 여러개의 버스가 존재하며, 환승이 없는 경우
    private static func HorizontalOCRMultipleLineType(filteredArray: [String], sortOfBuses: [String], sortOfBusNumber: [String]) -> (String, String, String) {
        var startStop: String = ""
        var busNumber: String = ""
        var endStop: String = ""
        
        if !sortOfBusNumber[0].isEmpty {
            busNumber = sortOfBusNumber.first ?? ""
        } else {
            print("No bus info.")
        }
        
        if let firstIndex = filteredArray.firstIndex(of: sortOfBuses[0]),
           let secondIndex = filteredArray.firstIndex(where: { $0 == "ETA" || $0 == busNumber }),
           firstIndex < secondIndex {
            let result = Array(filteredArray[(firstIndex + 1)...secondIndex].dropLast())
            startStop = stringArrayToStirng(stringArray: result)
        } else {
            print("Failed to extract busStopBoard.")
        }
        
        if let firstIndex = filteredArray.firstIndex(where: { $0 == "off" || $0 == "oft" || $0 == "otf" || $0 == "ott"}),
           let secondIndex = filteredArray.firstIndex(of: "GO"),
           firstIndex < secondIndex {
            let result = Array(filteredArray[(firstIndex + 1)..<secondIndex].dropLast())
            endStop = stringArrayToStirng(stringArray: result)
        } else {
            print("Failed to extract busStopToGetOff.")
        }
        busNumber = busNumber.filter { $0.isNumber }
        return (startStop, busNumber, endStop)
    }
    
    private static func stringArrayToStirng(stringArray: [String]) -> String {
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
