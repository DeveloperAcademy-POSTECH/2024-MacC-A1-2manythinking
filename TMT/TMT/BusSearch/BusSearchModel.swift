//
//  BusSearchModel.swift
//  TMT
//
//  Created by 김유빈 on 10/15/24.
//

struct BusStopInfo: Codable {
    var busNumber: String? // 노선명 (버스번호)
    var busType: Int? // 버스 타입
    var stopOrder: Int? // 순번
    var stopName: String? // 정류소명 (한글)
    var romanizedStopName: String? // 정류소명 (로마자 표기)
    var xCoordinate: String? // x좌표
    var yCoordinate: String? // y좌표
}
