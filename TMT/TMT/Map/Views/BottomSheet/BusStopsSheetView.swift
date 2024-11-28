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
                    // TODO: 정류장 지나칠 때마다 스크롤 위치 변화하는지 테스트 필요
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
            .foregroundStyle(.grey100)
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
                .font(.headline) // TODO: 서체
                .foregroundStyle(isPartOfJourney ? .textDefault : .grey400)
            
            Text("[\(stop.stopNameRomanized ?? "")]")
                .font(.subheadline) // TODO: 서체
                .foregroundStyle(.grey400)
            
            if isPartOfJourney {
                Text(stop.stopNameNaver ?? "")
                    .font(.headline) // TODO: 서체
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
