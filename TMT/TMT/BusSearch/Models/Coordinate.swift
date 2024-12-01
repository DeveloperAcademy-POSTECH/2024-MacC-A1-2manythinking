//
//  Coordinate.swift
//  TMT
//
//  Created by Choi Minkyeong on 12/1/24.
//

import SwiftUI

struct Coordinate: Identifiable {
    var id = UUID()
    var busNumber: String
    var stopNameKorean: String
    var stopOrder: Int
    var latitude: Double
    var longitude: Double
}
