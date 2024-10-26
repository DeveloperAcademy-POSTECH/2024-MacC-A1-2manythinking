//
//  ScanJourneyVC.swift
//  TMT
//
//  Created by Choi Minkyeong on 10/24/24.
//

import SwiftUI
import UIKit
import Vision
import PhotosUI

class ScanJourneyVC: UIViewController {
    var resultLabel: UILabel!
    
    var imageData: [UIImage] = [] {
        didSet {
            startOCR()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultLabel = UILabel(frame: CGRect(x: 20, y: 100, width: view.frame.width - 40, height: 600))
        resultLabel.textAlignment = .center
        resultLabel.textColor = .black
        resultLabel.numberOfLines = 0
        resultLabel.lineBreakMode = .byWordWrapping
        resultLabel.text = "인식 중..."
        
        view.addSubview(resultLabel)
    }
    
    func startOCR() {
        guard let image = imageData.first else {
            resultLabel.text = "이미지를 찾을 수 없습니다."
            return
        }
        
        guard let cgImage = image.cgImage else {
            resultLabel.text = "이미지를 처리할 수 없습니다."
            return
        }
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        let request = VNRecognizeTextRequest { [weak self] request, error in
            guard let self = self else { return }
            
            guard let observations = request.results as? [VNRecognizedTextObservation], error == nil else {
                DispatchQueue.main.async {
                    self.resultLabel.text = "텍스트 인식에 실패했습니다."
                }
                return
            }
            
            let recognizedText = observations.compactMap { $0.topCandidates(1).first?.string }.joined(separator: "\n")
            print("recognizedText: \(recognizedText)")
            
            let busJourneyInfo = BusJourneyExtractor.analyzeText(recognizedText)
            
            DispatchQueue.main.async {
                if recognizedText.isEmpty {
                    self.resultLabel.text = "인식된 텍스트가 없습니다."
                } else {
                    self.resultLabel.text = busJourneyInfo
                }
            }
        }
        
        if #available(iOS 16.0, *) {
            request.revision = VNRecognizeTextRequestRevision3
            request.recognitionLevel = .accurate
            request.recognitionLanguages = ["ko-KR"]
            request.usesLanguageCorrection = true
        } else {
            request.recognitionLanguages = ["en-US"]
            request.usesLanguageCorrection = true
        }
        
        do {
            try handler.perform([request])
        } catch {
            DispatchQueue.main.async {
                self.resultLabel.text = "OCR 요청 처리 중 에러가 발생했습니다: \(error.localizedDescription)"
            }
        }
    }
    
    
}
