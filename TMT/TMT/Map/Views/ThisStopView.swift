//
//  ThisStopView.swift
//  TMT
//
//  Created by Choi Minkyeong on 10/31/24.
//

import SwiftUI

struct ThisStopView: View {
    @EnvironmentObject var activityManager: LiveActivityManager
    @EnvironmentObject var imageHandler: ImageHandlerModel
    @State private var showingAlert = false
    @Binding var path: [String]
    
    var stopNameKorean: String
    var stopNameNaver: String
    var stopNameRomanized: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("KOR")
                .foregroundStyle(.yellow800)
                .frame(width: 52, height: 21)
                .background(.yellow300)
                .cornerRadius(4)
            Text("\(stopNameRomanized)")
                .font(.title)
                .bold()
            Text("\(stopNameKorean)")
                .padding(.bottom, 18)
            if !stopNameNaver.isEmpty {
                Text("ENG")
                    .foregroundStyle(.yellow800)
                    .frame(width: 52, height: 21)
                    .background(.yellow300)
                    .cornerRadius(4)
                Text("\(stopNameNaver)")
                    .padding(.bottom, 16)
            }
        }
        .padding(.top, 8)
        .padding(.horizontal, 16)
        .frame(width: 393, alignment: .leading)
        
        .background (
            Rectangle()
                .fill(.ultraThinMaterial)
                .edgesIgnoringSafeArea(.top)
                .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 2)
        )
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
        .navigationTitle("This Stop")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var backButton: some View {
        Button {
            showingAlert = true
        } label: {
            Image(systemName: "chevron.left")
                .foregroundStyle(.black)
        }
        .alert("End Navigation", isPresented: $showingAlert) {
            Button {
                showingAlert = false
            } label: {
                Text("Cancel")
                    .tint(.red600)
            }
            Button {
                activityManager.endLiveActivity()
                imageHandler.selectedImage = nil
                path.removeAll()
            } label: {
                Text("Exit")
                    .foregroundStyle(.busBlue)
            }
        } message: {
            Text("Are you sure you want to return to Home? Your navigation will end.")
        }
    }
}
