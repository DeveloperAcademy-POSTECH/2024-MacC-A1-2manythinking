//
//  InputDisplayModel.swift
//  TMT
//
//  Created by Choi Minkyeong on 11/14/24.
//

import SwiftUI
import PhotosUI

class InputDisplayModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var showAlertScreen: Bool = false
    @Published var showAlertText: Bool = false
    @Published var selectedImage: UIImage? = nil
    @Published var scannedJourneyInfo = ScannedJourneyInfo(busNumber: "", startStop: "", endStop: "")
    
    let ocrStarter = OCRStarterManager()
    
    /// 이미지를 로드하고 OCR을 진행하여 필요한 값을 뽑아냅니다.
    func loadImage(from item: PhotosPickerItem?, viewCategory: String, completion: @escaping () -> Void) {
        Task {
            guard let item = item else { return }
            if let data = try? await item.loadTransferable(type: Data.self),
               let image = UIImage(data: data) {
                selectedImage = image
                isLoading = true
                showAlertScreen = false
                showAlertText = false
                
                ocrStarter.startOCR(image: image) { info in
                    self.isLoading = false
                    if info.busNumber.isEmpty && info.startStop.isEmpty && info.endStop.isEmpty {
                        if viewCategory == "NotUploadedView" {
                            self.showAlertScreen = true
                        } else if viewCategory == "ScannedJourneyInfoView" {
                            self.showAlertText = true
                        }
                    } else {
                        self.scannedJourneyInfo = self.ocrStarter.splitScannedInfo(scannedJourneyInfo: info)
                    }
                    completion()
                }
            } else {
                completion()
            }
        }
    }
}
