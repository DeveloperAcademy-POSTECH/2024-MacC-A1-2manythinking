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
                        .font(.title.weight(.light))
                        .foregroundStyle(.grey300)
                }
            }
            .padding(.bottom, 8)
            
            Text("You've arrived")
                .font(.title.weight(.bold))
            Text("Hope you had a pleasant journey!")
                .foregroundStyle(.brandPrimary)
                .padding(.bottom, 8)
            
            Image("BusStopArrived")
                .resizable()
                .scaledToFill()
                .frame(height: 230)
                .padding(.bottom, 8)
            
            FilledButton(title: "End") {
                activityManager.endLiveActivity()
                imageHandler.selectedImage = nil
                hasNotArrived = false
                path.removeAll()
            }
        }
        .padding(16)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .foregroundStyle(.basicWhite)
        }
        .padding(16)
    }
}
