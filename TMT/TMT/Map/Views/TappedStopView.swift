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
    @Binding var stopOrder: Int?
    @Binding var tappedStopDetail: BusStopDetail
    
    var body: some View {
        if let stopOrder = stopOrder {
            BusStopDetailView(stopNameKorean: tappedStopDetail.endStopNameKorean, stopNameRomanized: tappedStopDetail.endStopNameRomanized, stopNameNaver: tappedStopDetail.endStopNameNaver, viewType: "")
                .padding(.horizontal, 16)
                .padding(.vertical, 21)
                .frame(width: 280)
                .background(SpeechBubbleShape().fill(.basicWhite))
                .offset(x: 14, y: 79)
                .onAppear {
                    updateStateOrder()
                    tappedStopDetail = BusStopDetail(endStopNameKorean: searchModel.filteredBusDataForNumber[stopOrder].stopNameKorean ?? "", endStopNameRomanized: searchModel.filteredBusDataForNumber[stopOrder].stopNameRomanized ?? "", endStopNameNaver: searchModel.filteredBusDataForNumber[stopOrder].stopNameNaver ?? "")
                }
                .onChange(of: selectedStopManager.selectedIndex) {
                    updateStateOrder()
                }
        } else {
            Text("Error is occured. Please try again.")
        }
    }
    private func updateStateOrder() {
        stopOrder = selectedStopManager.selectedIndex
    }
}
