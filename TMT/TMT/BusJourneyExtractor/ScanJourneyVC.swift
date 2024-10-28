//
//  ScanJourneyVC.swift
//  TMT
//
//  Created by Choi Minkyeong on 10/24/24.
//

import PhotosUI
import SwiftUI
import UIKit
import Vision

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
        resultLabel.text = "Analyzing..."
        
        view.addSubview(resultLabel)
    }
    
    func startOCR() {
        guard let image = imageData.first else {
            resultLabel.text = "Cannot find image. Please try it again."
            return
        }
        
        guard let cgImage = image.cgImage else {
            resultLabel.text = "Failed while processing image. Please try it again."
            return
        }
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        let request = VNRecognizeTextRequest { [weak self] request, error in
            guard let self = self else { return }
            
            guard let observations = request.results as? [VNRecognizedTextObservation], error == nil else {
                DispatchQueue.main.async {
                    self.resultLabel.text = "Failed to read data. Please make sure your all route is on the screenshot."
                }
                return
            }
            
            let recognizedText = observations.compactMap { $0.topCandidates(1).first?.string }.joined(separator: "\n")
            print("recognizedText: \(recognizedText)")
            
            let busJourneyInfo = BusJourneyExtractor.analyzeText(recognizedText)
            
            DispatchQueue.main.async {
                if recognizedText.isEmpty || busJourneyInfo == "" {
                    self.resultLabel.text = "Failed to fetch data. Please make sure your all route is on the screenshot."
                } else {
                    self.resultLabel.text = busJourneyInfo
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
            DispatchQueue.main.async {
                self.resultLabel.text = "Failed to fetch data: \(error.localizedDescription)"
            }
        }
    }
    
    
}
