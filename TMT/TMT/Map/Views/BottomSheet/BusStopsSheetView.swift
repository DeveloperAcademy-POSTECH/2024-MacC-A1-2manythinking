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
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        // TODO: 현재 정류장 표시도 해야 함.
                        ForEach(searchModel.filteredBusDataForNumber) { stop in
                            let isPartOfJourney = journeyModel.journeyStops.contains { $0.stopOrder == stop.stopOrder }
                            
                            BusStopRowView(stop: stop, isPartOfJourney: isPartOfJourney)
                                .id(stop.stopOrder)
                        }
                    }
                    .onAppear {
                        proxy.scrollTo(journeyModel.journeyStops.first!.stopOrder)
                    }
                    .onChange(of: journeyModel.lastPassedStopIndex) {
                        proxy.scrollTo(journeyModel.journeyStops[journeyModel.lastPassedStopIndex].stopOrder)
                        
                    }
                }
            }
        }
    }
}

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
        // TODO: 선 양 끝에 둥근 처리하기
        Rectangle()
            .frame(width: 8)
            .overlay {
                Circle() // TODO: 동그라미 이미지 교체하기
                    .foregroundStyle(.basicWhite)
                    .frame(width: 8, height: 8.4)
            }
            .foregroundStyle(isPartOfJourney ? .brandPrimary : .grey100)
            .padding(.leading, 57)
            .padding(.trailing, 28)
            .background(.backgroundModal)
    }
    
    private var busStopInfoView: some View {
        VStack(alignment: .leading, spacing: 0) {
            busStopNamesView
            
            Divider()
                .background(.busStopLine)
        }
        .background(isPartOfJourney ? .brandBackground  : .busStopUnselect)// TODO: 색상 추가되면 변경하기
    }
    
    private var busStopNamesView: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(stop.stopNameKorean ?? "")
                .body2Regular()
                .foregroundStyle(isPartOfJourney ? .textDefault : .grey400)

            Text("[\(stop.stopNameRomanized ?? "")]")
                .label3Regular()
                .foregroundStyle(.grey400)

            if isPartOfJourney {
                Text(stop.stopNameTranslated ?? "")
                    .body2Regular()
                    .foregroundStyle(.textDefault)
            }
        }
        .multilineTextAlignment(.leading)
        .padding(10)
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
