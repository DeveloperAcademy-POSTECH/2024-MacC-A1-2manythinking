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
                        // TODO: 추후 이미지인지 확인 후 변경해야함.
                        Text("X")
                    }
                }
            if let stopOrder = stopOrder {
                BusStopInfoView(stopNameKorean: searchModel.filteredBusDataForNumber[stopOrder].stopNameKorean ?? "", stopNameRomanized: searchModel.filteredBusDataForNumber[stopOrder].stopNameRomanized ?? "", stopNameNaver: searchModel.filteredBusDataForNumber[stopOrder].stopNameNaver ?? "")
                
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

// TODO: UIComponent에 들어가기 적절한지 의논해보기.
struct BusStopInfoView: View {
    var stopNameKorean: String
    var stopNameRomanized: String
    var stopNameNaver: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Korean")
                .foregroundStyle(.grey200)
                .font(.footnote)
            Text("\(stopNameKorean)")
                .foregroundStyle(.basicBlack)
                .font(.title2)
                .fontWeight(.bold)
            Text("[\(stopNameRomanized)]")
                .foregroundStyle(.grey500)
                .font(.footnote)
            Divider()
                .foregroundStyle(.grey100)
                .padding(.vertical, 9)
            Text("English")
                .foregroundStyle(.grey200)
                .font(.footnote)
            Text("\(stopNameNaver)")
                .foregroundStyle(.grey600)
                .font(.title2)
                .fontWeight(.bold)
        }
    }
}
