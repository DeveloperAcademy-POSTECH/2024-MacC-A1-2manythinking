//
//  BusSearchModel.swift
//  TMT
//
//  Created by 김유빈 on 10/15/24.
//

import Foundation

struct BusStopInfo: Codable, Identifiable {
    var id = UUID()
    var busNumber: String? // 노선명 (버스번호)
    var busType: Int? // 버스 타입
    var stopOrder: Int? // 순번
    var stopNameKorean: String? // 정류소명 (한글)
    var stopNameRomanized: String? // 정류소명 (로마자 표기)
    var xCoordinate: String? // x좌표
    var yCoordinate: String? // y좌표
}
