//
//  OCRProcessorManager.swift
//  TMT
//
//  Created by Choi Minkyeong on 10/24/24.
//

import Foundation

class OCRProcessorManager {
    static func analyzeText(_ recognizedString: String) -> ScannedJourneyInfo {
        let ocrExtractor = OCRExtractorManager()
        
        var extractedInfo: (busNumber: String, startStop: String, endStop: String) = ("", "", "")
        var sortOfBuses: [String] = []
        var sortOfBusNumber: [String] = []
        
        var stringInArray = recognizedString.components(separatedBy: CharacterSet.whitespacesAndNewlines)
        let firstMinIndex = stringInArray.enumerated().filter({ $0.element.contains("min") }).first?.offset ?? 0
        stringInArray.remove(at: firstMinIndex)
        
        let slicedArray = ocrExtractor.extractBusJourney(stringInArray: stringInArray)
        let filteredArray = slicedArray.filter { !$0.matches("\\b\\d+m\\b(?!in)") && $0 != "Best" && $0 != "route" }
        
        sortOfBuses = filteredArray.filter { BusColor.allColors.contains($0) }
        sortOfBusNumber = filteredArray.filter { element in
            BusNumber.allNumbers.contains(where: { element.contains($0) }) && !element.contains("명")
        }
        ocrExtractor.getBusNumber(sortOfBusNumber: sortOfBusNumber)
        
        // MARK: - 버스 경로 생김새에 따라 분기처리합니다.
        if let firstColorIndex = filteredArray.firstIndex(where: { element in
            sortOfBuses.contains(where: { busType in element.contains(busType) })
        }), firstColorIndex + 2 < filteredArray.count {
            let twoStepsAfterIndex = firstColorIndex + 2
            let threeStepsAfterIndex = firstColorIndex + 3
            if filteredArray[twoStepsAfterIndex] == "Get" || filteredArray[threeStepsAfterIndex] == "Get" {
                if sortOfBuses.count < 2 {
                    if sortOfBusNumber.count < 2 {
                        extractedInfo = ocrExtractor.verticalOneLineType(filteredArray: filteredArray,  arrivalWordsBack: ArrivalWordsBack.allBackWords)
                    } else {
                        extractedInfo = ocrExtractor.verticalMultipleLineType(filteredArray: filteredArray, arrivalWordsBack: ArrivalWordsBack.allBackWords)
                    }
                } else {
                    // TODO: 환승 노선은 다음 이터레이션에 구현될 예정입니다.
                }
            } else {
                if sortOfBuses.count < 2 {
                    if sortOfBusNumber.count < 2 {
                        extractedInfo = ocrExtractor.horizontalOneLineType(filteredArray: filteredArray, sortOfBuses: sortOfBuses)
                    } else {
                        extractedInfo = ocrExtractor.horizontalMultipleLineType(filteredArray: filteredArray, sortOfBuses: sortOfBuses)
                    }
                } else {
                    // TODO: 환승 노선은 다음 이터레이션에 구현될 예정입니다.
                }
            }
        }
        
        return ScannedJourneyInfo(busNumber: extractedInfo.busNumber, startStop: extractedInfo.startStop, endStop: extractedInfo.endStop)
    }
}
