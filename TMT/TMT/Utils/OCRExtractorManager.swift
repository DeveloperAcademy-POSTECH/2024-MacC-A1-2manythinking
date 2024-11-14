//
//  OCRExtractorManager.swift
//  TMT
//
//  Created by Choi Minkyeong on 10/29/24.
//

import Foundation

class OCRExtractorManager {
    private var startStop: String = ""
    private var busNumber: String = ""
    private var endStop: String = ""
    
    /// 사용자가 실제로 이용할 루트만 문자열에 남깁니다.
    func extractBusJourney(stringInArray: [String]) -> [String] {
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
    func verticalOneLineType(filteredArray: [String],arrivalWordsBack: [String]) -> (startStop: String, busNumber: String, endStop: String) {
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
        
        return (busNumber, startStop, endStop)
    }
    
    /// OCR이 세로로 읽히고, 버스 경로에 여러개의 버스가 존재하며, 환승이 없는 경우
    func verticalMultipleLineType(filteredArray: [String], arrivalWordsBack: [String]) -> (startStop: String, busNumber: String, endStop: String) {
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
        return (busNumber, startStop, endStop)
    }
    
    /// OCR이 가로로 읽히고, 버스 경로에 하나의 버스만 존재하며, 환승이 없는 경우
    func horizontalOneLineType(filteredArray: [String], sortOfBuses: [String]) -> (startStop: String, busNumber: String, endStop: String) {
        print("filteredArray: \(filteredArray)")
        if let firstIndex = filteredArray.firstIndex(of: sortOfBuses[0]),
           let secondIndex = filteredArray.firstIndex(where: { $0 == "ETA" || $0 == busNumber }),
           firstIndex < secondIndex {
            let result = Array(filteredArray[(firstIndex + 1)..<secondIndex].dropLast())
            startStop = stringArrayToStirng(stringArray: result)
        } else {
            print("Failed to extract busStopBoard.")
        }
        
        getEndStopInHorizontal(filteredArray: filteredArray)
        return (busNumber, startStop, endStop)
    }
    
    /// OCR이 가로로 읽히고, 버스 경로에 여러개의 버스가 존재하며, 환승이 없는 경우
    func horizontalMultipleLineType(filteredArray: [String], sortOfBuses: [String]) -> (startStop: String, busNumber: String, endStop: String) {
        if let firstIndex = filteredArray.firstIndex(of: sortOfBuses[0]),
           let secondIndex = filteredArray.firstIndex(where: { $0 == "ETA" || $0 == busNumber }),
           firstIndex < secondIndex {
            let result = Array(filteredArray[(firstIndex + 1)...secondIndex].dropLast())
            startStop = stringArrayToStirng(stringArray: result)
        } else {
            print("Failed to extract busStopBoard.")
        }
        
        getEndStopInHorizontal(filteredArray: filteredArray)
        busNumber = busNumber.filter { $0.isNumber }
        
        return (busNumber, startStop, endStop)
    }
    
    func getBusNumber(sortOfBusNumber: [String]) {
        if !sortOfBusNumber.isEmpty {
            busNumber = sortOfBusNumber.first ?? ""
        } else {
            print("No bus info.")
        }
    }
    
    func stringArrayToStirng(stringArray: [String]) -> String {
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
    
    func getEndStopInHorizontal(filteredArray: [String]) {
        if let firstIndex = filteredArray.firstIndex(where: { $0 == "off" || $0 == "oft" || $0 == "otf" || $0 == "ott"}),
           let secondIndex = filteredArray.firstIndex(of: "GO"),
           firstIndex < secondIndex {
            let result = Array(filteredArray[(firstIndex + 1)..<secondIndex].dropLast())
            endStop = stringArrayToStirng(stringArray: result)
        } else {
            print("Failed to extract busStopToGetOff.")
        }
    }
}
