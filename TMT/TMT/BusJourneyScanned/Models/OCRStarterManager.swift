//
//  OCRStarterManager.swift
//  TMT
//
//  Created by Choi Minkyeong on 10/24/24.
//

import Vision
import UIKit

class OCRStarterManager {
    func startOCR(image: UIImage, completion: @escaping ((busNumber: String, startStop: String, endStop: String)) -> Void) {
        guard let cgImage = image.cgImage else {
            print("Failed while processing image.")
            return
        }
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = VNRecognizeTextRequest { request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation], error == nil else {
                print("Failed to read data.")
                return
            }
            
            let recognizedText = observations.compactMap { $0.topCandidates(1).first?.string }.joined(separator: "\n")
            let busJourneyInfo = OCRProcessorManager.analyzeText(recognizedText)
            
            DispatchQueue.main.async {
                completion(busJourneyInfo)
            }
        }
        
        request.revision = VNRecognizeTextRequestRevision3
        request.recognitionLevel = .accurate
        request.recognitionLanguages = ["ko-KR"]
        request.usesLanguageCorrection = true
        
        do {
            try handler.perform([request])
        } catch {
            print("Failed to fetch data: \(error.localizedDescription)")
        }
    }
    
    func splitScannedInfo(scannedJourneyInfo: (busNumber: String, startStop: String, endStop: String)) -> (busNumber: String, startStop: String, endStop: String) {
        var busNumber = scannedJourneyInfo.busNumber
        var startStop = scannedJourneyInfo.startStop
        var endStop = scannedJourneyInfo.endStop
        
        if let lastChar = scannedJourneyInfo.busNumber.last, lastChar == " " {
            busNumber = String(scannedJourneyInfo.busNumber.dropLast())
        }
        
        if let lastChar = scannedJourneyInfo.startStop.last, lastChar == " " {
            startStop = String(scannedJourneyInfo.startStop.dropLast())
        }
        
        if let lastChar = scannedJourneyInfo.endStop.last, lastChar == " " {
            endStop = String(scannedJourneyInfo.endStop.dropLast())
        }
        
        return (busNumber, startStop, endStop)
    }
}
