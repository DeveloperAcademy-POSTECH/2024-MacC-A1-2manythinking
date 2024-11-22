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
                // TODO: 남은 정류장 수 밑에 뜨는 선 수정하기. 그림자
                Rectangle()
                    .foregroundStyle(.basicBlack.opacity(0.25))
                    .shadow(radius: 2.5, y: 2)
                    .frame(height: 2)
                
                // TODO: 현재 정류장 표시도 해야 함.
                ForEach(searchModel.filteredBusDataForNumber) { stop in
                    let isPartOfJourney = journeyModel.journeyStops.contains { $0.stopOrder == stop.stopOrder }
                    BusStopRow(stop: stop, isPartOfJourney: isPartOfJourney)
                }
            }
        }
    }
}

// TODO: 선 양 끝에 둥근 처리하기

struct BusStopRow: View {
    let stop: BusStop
    let isPartOfJourney: Bool
    //    let isCurrentStop: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            journeyIndicator

            stopInfoView
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
    
    private var stopInfoView: some View {
        VStack(alignment: .leading, spacing: 0) {
            stopNameView
            
            Divider()
                .background(isPartOfJourney ? .grey50 : .grey100)
        }
        .background(isPartOfJourney ? .basicWhite : .grey30) // TODO: 색상 추가되면 변경하기
    }
    
    private var stopNameView: some View {
        // TODO: 정류장 이름 데이터 없을 때 대처하기. 뭐로 넣지
        // TODO: 서체 적용하기
        Group {
            if let korean = stop.stopNameKorean,
               let romanized = stop.stopNameRomanized,
               let translated = stop.stopNameNaver {
                VStack(alignment: .leading, spacing: 0) {
                    
                    Text(korean)
                        .font(.headline) // TODO: 서체
                        .foregroundStyle(.grey500) // TODO: 디자인 답변 오면 색상 수정하기
                    
                    Text("[\(romanized)]")
                        .font(.subheadline) // TODO: 서체
                        .foregroundStyle(.grey300)
                    
                    if isPartOfJourney {
                        Text(translated)
                            .font(.subheadline) // TODO: 서체
                            .foregroundStyle(.grey500) // TODO: 디자인 답변 오면 색상 수정하기
                    }
                }
                .lineLimit(1)
                .padding(10)
            } else {
                missingDataView
            }
        }
    }
    
    private var missingDataView: some View {
        Text("데이터 없음")
            .padding(10)
            .padding(.vertical, 15)
            .foregroundStyle(isPartOfJourney ? .basicBlack : .grey400)
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
        BusStop(stopOrder: 7, stopNameKorean: "을지로입구역을지로입구역을지로입구역ㅇㅇㅇd", stopNameRomanized: "Euljiro-iㅇㅇㅇㅇㅇㅇㅇㄴㅇㅁㄴㅇㅁㄹㅇㄹㅇㄴㄹㄴㅇㄹㅇㄴㄹㅇㄴㄹpgu-yeok", stopNameNaver: "Euljiro Station"),
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
