//
//  ScanJourneyVCRepresentable.swift
//  TMT
//
//  Created by Choi Minkyeong on 10/24/24.
//

import SwiftUI

struct ScanJourneyVCRepresentable: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    func makeUIViewController(context: Context) -> ScanJourneyVC {
        let viewController = ScanJourneyVC()
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: ScanJourneyVC, context: Context) {
        if let image = image {
            uiViewController.imageData = [image]
        }
    }
}
