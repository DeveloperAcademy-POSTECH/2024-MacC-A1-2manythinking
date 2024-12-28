//
//  BusStopArrivalView.swift
//  TMT
//
//  Created by Choi Minkyeong on 11/25/24.
//

import SwiftUI

struct BusStopArrivalView: View {
    @EnvironmentObject var activityManager: LiveActivityManager
    @EnvironmentObject var imageHandler: ImageHandlerModel
    @EnvironmentObject var journeyModel: JourneySettingModel
    @EnvironmentObject var locationManager: LocationManager
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
                .foregroundStyle(.textDefault)
                .font(.system(size: 24, weight: .bold))
                .padding(.bottom, 4)
            
            Text("Hope you had a pleasant journey!")
                .foregroundStyle(.brandPrimary)
                .font(.system(size: 16, weight: .medium))
                .padding(.bottom, 8)
            
            Image("BusStopArrived")
                .resizable()
                .scaledToFill()
                .frame(height: 230)
                .padding(.bottom, 8)
            
            FilledButton(title: "End") {
                activityManager.endLiveActivity(destinationInfo: journeyModel.journeyStops.last!)
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
