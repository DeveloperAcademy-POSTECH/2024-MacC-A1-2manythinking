//
//  BusDataMock.swift
//  TMT
//
//  Created by 김유빈 on 11/23/24.
//

extension BusStop {
    static var busStopDummy: [BusStop] {
        return [
            BusStop(stopOrder: 0, stopNameKorean: "종각역"),
            BusStop(stopOrder: 1, stopNameKorean: "종각역", stopNameRomanized: "Jonggak-yeok", stopNameNaver: "Jonggak Station"),
            BusStop(stopOrder: 2, stopNameKorean: "을지로입구역", stopNameRomanized: "Euljiro-ipgu-yeok", stopNameNaver: "Euljiro Station"),
            BusStop(stopOrder: 3, stopNameKorean: "죽전역", stopNameRomanized: "Juk-jeon-yeok", stopNameNaver: "Jukjeon Station"),
            BusStop(stopOrder: 4, stopNameKorean: "강남역", stopNameRomanized: "Gang-nam-yeok", stopNameNaver: "Gangnam Station"),
            
            BusStop(stopOrder: 5, stopNameKorean: "강남역", stopNameRomanized: "Gang-nam-yeok", stopNameNaver: "Gangnam Station"),
            BusStop(stopOrder: 6, stopNameKorean: "죽전역", stopNameRomanized: "Juk-jeon-yeok", stopNameNaver: "Jukjeon Station"),
            BusStop(stopOrder: 7, stopNameKorean: "을지로입구역을지로입구역을지로입구역을지로입구역", stopNameRomanized: "Euljiro-ipgu-yeokEuljiro-ipgu-yeokEuljiro-ipgu-yeokEuljiro-ipgu-yeok", stopNameNaver: "Euljiro Station"),
            BusStop(stopOrder: 8, stopNameKorean: "종각역", stopNameRomanized: "Jonggak-yeok", stopNameNaver: "Jonggak Station"),
            BusStop(stopOrder: 9, stopNameKorean: "서울역", stopNameRomanized: "Seoul-yeok", stopNameNaver: "Seoul Station")
        ]
    }
    
    static var journeyStopDummy: [BusStop] {
        return [
            BusStop(stopOrder: 1, stopNameKorean: "종각역", stopNameRomanized: "Jonggak-yeok", stopNameNaver: "Jonggak Station"),
            BusStop(stopOrder: 2, stopNameKorean: "을지로입구역", stopNameRomanized: "Euljiro-ipgu-yeok", stopNameNaver: "Euljiro Station"),
            BusStop(stopOrder: 3, stopNameKorean: "죽전역", stopNameRomanized: "Juk-jeon-yeok", stopNameNaver: "Jukjeon Station")
        ]
    }
}
