//
//  TappedStopView.swift
//  TMT
//
//  Created by Choi Minkyeong on 11/25/24.
//

import SwiftUI

struct TappedStopView: View {
    @EnvironmentObject var selectedStopManager: SelectedStopManager
    @EnvironmentObject var searchModel: BusSearchModel
    @State private var stopOrder: Int? = 0
    @Binding var tappedStop: BusStop
    
    var body: some View {
        VStack {
            BusStopDetailView(stopNameKorean: tappedStop.stopNameKorean ?? "", stopNameRomanized: tappedStop.stopNameRomanized ?? "", stopNameNaver: tappedStop.stopNameNaver ?? "", viewType: "")
                .padding(.horizontal, 16)
                .padding(.vertical, 21)
                .offset(y: 10 )
                .frame(width: 280)
                .background(PopoverView().fill(.basicWhite)) // TODO: 색상 변경하기
                .offset(x: 14, y: 79)
            
        }
        .onAppear {
            updateStateOrder()
            if let stopOrder = stopOrder {
                tappedStop = searchModel.filteredBusDataForNumber[stopOrder]
            } else {
                print("Error is occured. Please try again.")
            }
        }
        .onChange(of: selectedStopManager.selectedIndex) {
            updateStateOrder()
        }
    }
    
    private func updateStateOrder() {
        stopOrder = selectedStopManager.selectedIndex
    }
}
