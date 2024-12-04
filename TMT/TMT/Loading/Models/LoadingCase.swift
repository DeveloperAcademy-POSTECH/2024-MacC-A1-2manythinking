//
//  LoadingViewEnum.swift
//  TMT
//
//  Created by 김유빈 on 12/4/24.
//

enum Loading: CaseIterable {
    case loadingDynamic
    case loadingCompare

    var description: String {
        switch self {
        case .loadingDynamic: return "Match with\nDynamic Island"
        case .loadingCompare: return "Compare\nRomanization"
        }
    }

    var loadingImage: String {
        switch self {
        case .loadingDynamic: return "LoadingDynamic"
        case .loadingCompare: return "LoadingCompare"
        }
    }
}
