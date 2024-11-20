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
            HStack {
                Spacer()
                Button {
                    selectedStopManager.isTapped = false
                } label: {
                    // TODO: 하이파이랑 똑같이 커스텀이 안되는데, 이미지 에셋 요청하기
                    // x 버튼 사이즈도 바꿔야함.
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(Color(red: 0.5, green: 0.5, blue: 0.5).opacity(0.5))
                        .frame(width: 30, height: 30)
                }
            }
            if let stopOrder = stopOrder {
                BusStopDetailView(stopNameKorean: searchModel.filteredBusDataForNumber[stopOrder].stopNameKorean ?? "", stopNameRomanized: searchModel.filteredBusDataForNumber[stopOrder].stopNameRomanized ?? "", stopNameNaver: searchModel.filteredBusDataForNumber[stopOrder].stopNameNaver ?? "")
                
            } else {
                Text("Error is occured. Please try again.")
            }
        }
        .padding(.horizontal, 32)
        .padding(.bottom, 32)
        .padding(.top, 12)
        .background {
            Rectangle()
                .foregroundStyle(.basicWhite)
                .frame(maxWidth: .infinity)
                .ignoresSafeArea()
        }
        .onAppear(perform: updateStateOrder)
        .onChange(of: selectedStopManager.selectedIndex) {
            updateStateOrder()
        }
    }
    
    private func updateStateOrder() {
        stopOrder = selectedStopManager.selectedIndex
    }
}
