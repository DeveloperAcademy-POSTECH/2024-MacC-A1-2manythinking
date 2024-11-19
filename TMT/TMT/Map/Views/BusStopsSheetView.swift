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
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // TODO: 현재 정류장 표시도 해야 함.
                ForEach(searchModel.filteredBusDataForNumber) { stop in
                    BusStopRow(stop: stop,
                               isPartOfJourney: journeyModel.journeyStops.contains(where: { $0.stopOrder == stop.stopOrder }),
                               isCurrentStop: stop.stopOrder == journeyModel.journeyStops[journeyModel.lastPassedStopIndex].stopOrder)
                }
            }
        }
    }
}

struct BusStopRow: View {
    let stop: BusStop
    let isPartOfJourney: Bool
    let isCurrentStop: Bool
    
    var body: some View {
        Rectangle()
            .frame(height: 80)
            .foregroundStyle(.clear)
            .overlay {
                HStack(spacing: 0) {
                    Rectangle()
                        .frame(width: 8)
                        .overlay {
                            Circle()
                                .foregroundStyle(.basicWhite)
                                .frame(width: 8, height: 8)
                        }
                        .padding(.leading, 58.5) // TODO: padding 수정
                        .padding(.trailing, 18) // TODO: padding 수정
                        .foregroundStyle(isPartOfJourney ? .brandPrimary : .grey100)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        stopNameView
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
            }
    }
    
    private var stopNameView: some View {
        // TODO: 정류장 이름 데이터 없을 때 대처하기. 뭐로 넣지
        Group {
                if let korean = stop.stopNameKorean,
                   let romanized = stop.stopNameRomanized,
                   let naver = stop.stopNameNaver {
                    VStack(alignment: .leading, spacing: 2) {

                    Text(korean)
                        .font(.headline)
                    
                    Text("[\(romanized)]")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text(naver)
                        .font(.subheadline)
                }
                } else {
                    // 하나라도 Nil이면 안 뜨는군. 당연함
                    Text("데이터 없음")
                        .foregroundStyle(.basicBlack)
                }
        }
    }
}

#Preview {
    let searchModel = BusSearchModel()
    let journeyModel = JourneySettingModel(searchModel: searchModel)
        
    searchModel.filteredBusDataForNumber = [
        BusStop(stopOrder: 0, stopNameKorean: "종각역"),
        BusStop(stopOrder: 1, stopNameKorean: "종각역", stopNameRomanized: "Jonggak-yeok", stopNameNaver: "Jonggak Station"),
        BusStop(stopOrder: 2, stopNameKorean: "을지로입구역", stopNameRomanized: "Euljiro-ipgu-yeok", stopNameNaver: "Euljiro Station"),
        BusStop(stopOrder: 3, stopNameKorean: "죽전역", stopNameRomanized: "Juk-jeon-yeok", stopNameNaver: "Jukjeon Station"),
        BusStop(stopOrder: 4, stopNameKorean: "강남역", stopNameRomanized: "Gang-nam-yeok", stopNameNaver: "Gangnam Station"),
        
        BusStop(stopOrder: 5, stopNameKorean: "강남역", stopNameRomanized: "Gang-nam-yeok", stopNameNaver: "Gangnam Station"),
        BusStop(stopOrder: 6, stopNameKorean: "죽전역", stopNameRomanized: "Juk-jeon-yeok", stopNameNaver: "Jukjeon Station"),
        BusStop(stopOrder: 7, stopNameKorean: "을지로입구역을지로입구역을지로입구역d", stopNameRomanized: "Euljiro-ipgu-yeok", stopNameNaver: "Euljiro Station"),
        BusStop(stopOrder: 8, stopNameKorean: "종각역", stopNameRomanized: "Jonggak-yeok", stopNameNaver: "Jonggak Station"),
        BusStop(stopOrder: 9, stopNameKorean: "서울역", stopNameRomanized: "Seoul-yeok", stopNameNaver: "Seoul Station")
    ]
    
    journeyModel.journeyStops = [
        BusStop(stopOrder: 1, stopNameKorean: "종각역", stopNameRomanized: "Jonggak-yeok", stopNameNaver: "Jonggak Station"),
        BusStop(stopOrder: 2, stopNameKorean: "을지로입구역", stopNameRomanized: "Euljiro-ipgu-yeok", stopNameNaver: "Euljiro Station"),
        BusStop(stopOrder: 3, stopNameKorean: "죽전역", stopNameRomanized: "Juk-jeon-yeok", stopNameNaver: "Jukjeon Station")
    ]
    
    return BusStopsSheetView()
        .environmentObject(searchModel)
        .environmentObject(journeyModel)
}
