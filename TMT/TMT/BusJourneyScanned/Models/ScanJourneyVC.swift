//
//  ScanJourneyVC.swift
//  TMT
//
//  Created by Choi Minkyeong on 10/24/24.
//

import Vision
import UIKit

final class OCRService {
    func startOCR(image: UIImage, completion: @escaping (String) -> Void) {
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
            
            let busJourneyInfo = BusJourneyExtractor.analyzeText(recognizedText)
            DispatchQueue.main.async {
                completion(busJourneyInfo ?? "")
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
    
//    /// PhotosPicker에서 받은 사진에서 텍스트를 고르는 startOCR 함수를 실행하고 예외처리합니다.
//    func photoToText(_ image: UIImage) -> String {
//        let ocrService = OCRService()
//        var isLoading: Bool = false
//        
//        ocrService.startOCR(image: image) { info in
//            isLoading = false
//            if !info.isEmpty {
//                scannedJourneyInfo = info
//            }
//        }
//        return "Hello, World!"
//    }
}
