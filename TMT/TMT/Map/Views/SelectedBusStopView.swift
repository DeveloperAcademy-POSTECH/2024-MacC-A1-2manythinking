//
//  SelectedBusStopView.swift
//  TMT
//
//  Created by Choi Minkyeong on 11/19/24.
//

import SwiftUI

struct SelectedBusStopView: View {
    @EnvironmentObject var selectedStopManager: SelectedStopManager
    @EnvironmentObject var searchModel: BusSearchModel
    @State private var stopOrder: Int? = 0
    
    var body: some View {
        VStack {
            if let stopOrder = stopOrder {
                Text("searchModel: \(searchModel.filteredBusDataForNumber[stopOrder].stopNameKorean)")
            } else {
                Text("Error is occured. Please try again.")
            }
            Button {
                selectedStopManager.isTapped = false
            } label: {
                Text("Cancel")
            }
            Text("SelectedBusStopView")
                .background()
        }
        .onChange(of: selectedStopManager.selectedIndex) {
            stopOrder = selectedStopManager.selectedIndex
        }
        
    }
}
