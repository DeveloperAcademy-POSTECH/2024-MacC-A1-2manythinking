//
//  BusStopsSheetView.swift
//  TMT
//
//  Created by 김유빈 on 11/18/24.
//

import SwiftUI

struct BusStopsSheetView: View {
    @EnvironmentObject var searchModel: BusSearchModel
    @EnvironmentObject var journeyModel: JourneySettingModel
    
    var body: some View {
        VStack(spacing: 4) {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // TODO: 현재 정류장 표시도 해야 함.
                    ForEach(searchModel.filteredBusDataForNumber) { stop in
                        let isPartOfJourney = journeyModel.journeyStops.contains { $0.stopOrder == stop.stopOrder }
                        BusStopRowView(stop: stop, isPartOfJourney: isPartOfJourney)
                    }
                }
            }
        }
    }
}

// TODO: 선 양 끝에 둥근 처리하기

struct BusStopRowView: View {
    let stop: BusStop
    let isPartOfJourney: Bool
    //    let isCurrentStop: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            journeyIndicator
            
            busStopInfoView
        }
    }
    
    private var journeyIndicator: some View {
        Rectangle()
            .frame(width: 8)
            .overlay {
                Circle() // TODO: 동그라미 이미지 교체하기
                    .foregroundStyle(.basicWhite)
                    .frame(width: 8, height: 8.4)
            }
            .padding(.leading, 57)
            .padding(.trailing, 28)
            .foregroundStyle(isPartOfJourney ? .brandPrimary : .grey100)
    }
    
    private var busStopInfoView: some View {
        VStack(alignment: .leading, spacing: 0) {
            busStopNamesView
            
            Divider()
                .background(isPartOfJourney ? .grey50 : .grey100)
        }
        .background(isPartOfJourney ? .basicWhite : .grey30) // TODO: 색상 추가되면 변경하기
    }
    
    private var busStopNamesView: some View {
        // TODO: 서체 적용하기
        Group {
            VStack(alignment: .leading, spacing: 0) {
                Text(stop.stopNameKorean ?? "")
                    .font(.headline) // TODO: 서체
                    .foregroundStyle(.grey500) // TODO: 디자인 답변 오면 색상 수정하기
                
                Text("[\(stop.stopNameRomanized ?? "")]")
                    .font(.subheadline) // TODO: 서체
                    .foregroundStyle(.grey300)
                
                if isPartOfJourney {
                    Text(stop.stopNameNaver ?? "")
                        .font(.subheadline) // TODO: 서체
                        .foregroundStyle(.grey500) // TODO: 디자인 답변 오면 색상 수정하기
                }
            }
            .lineLimit(1)
            .padding(10)
        }
    }
}

#Preview {
    let searchModel = BusSearchModel()
    let journeyModel = JourneySettingModel(searchModel: searchModel)
    
    searchModel.filteredBusDataForNumber = BusStop.busStopDummy
    
    journeyModel.journeyStops = BusStop.journeyStopDummy
    
    return BusStopsSheetView()
        .environmentObject(searchModel)
        .environmentObject(journeyModel)
}