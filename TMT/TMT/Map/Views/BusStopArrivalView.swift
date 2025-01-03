//
//  BusStopArrivalView.swift
//  TMT
//
//  Created by Choi Minkyeong on 11/25/24.
//

import SwiftUI

struct BusStopArrivalView: View {
    @EnvironmentObject var imageHandler: ImageHandlerModel
    @EnvironmentObject var journeyModel: JourneySettingModel
    @Binding var hasNotArrived: Bool
    @Binding var path: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Spacer()
                Button {
                    hasNotArrived = true
                } label: {
                    Image(systemName: "xmark.circle")
                        .foregroundStyle(.grey300)
                        .font(.system(size: 24))
                }
            }
            .padding(.bottom, 8)
            
            Text("You've arrived")
                .title2()
                .foregroundStyle(.textDefault)
                .padding(.bottom, 4)
            
            Text("Hope you had a pleasant journey!")
                .body2Medium()
                .foregroundStyle(.brandPrimary)
                .padding(.bottom, 8)
            
            Image("BusStopArrived")
                .resizable()
                .scaledToFill()
                .frame(height: 230)
                .padding(.bottom, 8)
            
            FilledButton(title: "End") {
                LiveActivityManager.shared.endLiveActivity()
                imageHandler.selectedImage = nil
                hasNotArrived = false
                path.removeAll()
            }
        }
        .padding(16)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .foregroundStyle(.backgroundModal)
        }
        .padding(16)
    }
}
