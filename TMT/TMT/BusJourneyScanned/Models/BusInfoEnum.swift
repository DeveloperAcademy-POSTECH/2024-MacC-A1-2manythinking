//
//  BusInfoEnum.swift
//  TMT
//
//  Created by Choi Minkyeong on 10/28/24.
//

enum BusColor: String, CaseIterable {
    case blue = "Blue"
    case general = "General"
    case express = "Express"
    case green = "Green"
    case town = "Town"

    static var allColors: [String] {
        return BusColor.allCases.map { $0.rawValue }
    }
}

enum BusNumber: String, CaseIterable {
    case bus206 = "206"
    case bus207 = "207"
    case bus209 = "209"
    case bus216 = "216"
    case bus219 = "219"
    case bus302 = "302"
    case bus305 = "305"
    case bus306 = "306"
    case bus308 = "308"
    case bus600 = "600"
    case bus700 = "700"
    case bus800 = "800"
    case bus900 = "900"
    case bus110 = "110"
    case bus111 = "111"
    case bus120 = "120"
    case bus121 = "121"
    case bus130 = "130"
    case bus131 = "131"
    case bus5000 = "5000"
    case bus9000 = "9000"
    case bus580 = "580"

    static var allNumbers: [String] {
        return BusNumber.allCases.map { $0.rawValue }
    }
}

enum ArrivalWordsFront: String, CaseIterable {
    case min = "min"
    case interval = "Interval:"
    case no = "No"

    static var allFrontWords: [String] {
        return ArrivalWordsFront.allCases.map { $0.rawValue }
    }
}

enum ArrivalWordsBack: String, CaseIterable {
    case stops = "stops"
    case weekdays = "Weekdays"
    case everyday = "Everyday"
    case weekends = "Weekends"
    case eta = "ETA"

    static var allBackWords: [String] {
        return ArrivalWordsBack.allCases.map { $0.rawValue }
    }
}

