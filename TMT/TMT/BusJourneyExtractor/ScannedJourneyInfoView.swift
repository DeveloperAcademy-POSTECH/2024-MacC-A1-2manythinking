//
//  ScannedJourneyInfoView.swift
//  TMT
//
//  Created by Choi Minkyeong on 11/3/24.
//

import SwiftUI
import PhotosUI

struct ScannedJourneyInfoView: View {
    @State private var busNumber: String = ""
    @State private var startStop: String = ""
    @State private var endStop: String = ""
    @State private var pickedItem: PhotosPickerItem? = nil
    @Binding var scannedJourneyInfo: String
    @Binding var selectedImage: UIImage?
    @Binding var isLoading: Bool
    
    private let ocrService = OCRService()
    
    var body: some View {
        VStack(alignment: .leading) {
            uploadedInfoBox(title: "Bus Number", scannedInfo: $busNumber)
            uploadedInfoBox(title: "Departure Stop", scannedInfo: $startStop)
            uploadedInfoBox(title: "Arrival Stop", scannedInfo: $endStop)
            
            HStack(spacing: 0) {
                PhotosPicker(selection: $pickedItem, matching: .screenshots) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.Brand.primary, lineWidth: 1)
                        
                        Text("Reupload")
                            .foregroundStyle(Color.Brand.primary)
                    }
                    .padding(.trailing, 8)
                }
                .onChange(of: pickedItem) { newItem in
                    Task {
                        scannedJourneyInfo = ""
                        if let data = try? await newItem?.loadTransferable(type: Data.self),
                           let image = UIImage(data: data) {
                            selectedImage = image
                            ocrService.startOCR(image: image) { info in
                                isLoading = false
                                if !info.isEmpty {
                                    scannedJourneyInfo = info
                                }
                            }
                        }
                    }
                }
                
                Button {
                    // TODO: Start Live Activities, and convert to map.
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.Brand.primary)
                            .stroke(Color.Brand.primary)
                        Text("Start")
                            .foregroundStyle(.black)
                    }
                }
            }
            .frame(height: 52)
            .padding(.vertical, 12.5)
        }
        .onAppear {
            splitScannedInfo()
        }
    }
    
    private func splitScannedInfo() {
        let splitted = scannedJourneyInfo.split(separator: ",")
        if splitted.count >= 3 {
            busNumber = String(splitted[1])
            startStop = String(splitted[0])
            endStop = String(splitted[2])
        }
    }
    
    private func uploadedInfoBox(title: String, scannedInfo: Binding<String>) -> some View {
        VStack(alignment: .leading) {
            Text("\(title)")
                .foregroundStyle(Color.Basic.grey300)
            TextField("\(scannedInfo.wrappedValue)", text: scannedInfo)
                .bold()
                .font(.title)
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .center)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(Color.Basic.grey100, lineWidth: 1)
                        .background(Color.white.cornerRadius(8))
                )
                .keyboardType(title == "Bus Number" ? .numberPad : .default)
        }
        .padding(.bottom, 16)
    }
}
