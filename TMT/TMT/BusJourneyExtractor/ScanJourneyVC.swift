//
//  ScanJourneyVC.swift
//  TMT
//
//  Created by Choi Minkyeong on 10/24/24.
//

import Vision
import UIKit

class OCRService {
    static let shared = OCRService()
    private var currentInfo: String = ""
    private init() {}
    
    func startOCR(image: UIImage, completion: @escaping (String) -> Void) {
        currentInfo = ""
        guard let cgImage = image.cgImage else {
            completion("Failed while processing image.")
            return
        }
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = VNRecognizeTextRequest { request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation], error == nil else {
                completion("Failed to read data.")
                return
            }
            
            let recognizedText = observations.compactMap { $0.topCandidates(1).first?.string }.joined(separator: "\n")
            print("recognizedText: \(recognizedText)")
            
            if recognizedText == "" {
                DispatchQueue.main.async {
                    completion("")
                }
            } else {
                let busJourneyInfo = BusJourneyExtractor.analyzeText(recognizedText)
                DispatchQueue.main.async {
                    self.currentInfo = busJourneyInfo ?? ""
                    completion(self.currentInfo)
                }
            }
        }
        
        request.revision = VNRecognizeTextRequestRevision3
        request.recognitionLevel = .accurate
        request.recognitionLanguages = ["ko-KR"]
        request.usesLanguageCorrection = true
        
        do {
            try handler.perform([request])
        } catch {
            completion("Failed to fetch data: \(error.localizedDescription)")
        }
    }
}
