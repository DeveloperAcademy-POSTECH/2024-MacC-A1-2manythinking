//
//  SelectedBusStopView.swift
//  TMT
//
//  Created by Choi Minkyeong on 11/19/24.
//

import SwiftUI

struct SelectedBusStopView: View {
    @EnvironmentObject var sharedViewModel: SharedViewModel
    
    var body: some View {
        VStack {
            Button {
                sharedViewModel.isTapped = false
            } label: {
                Text("Cancel")
            }
            Text("SelectedBusStopView")
                .background()
        }
        
    }
}
