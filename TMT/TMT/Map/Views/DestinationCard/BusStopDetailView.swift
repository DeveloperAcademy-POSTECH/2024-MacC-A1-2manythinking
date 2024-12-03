//
//  BusStopDetailView.swift
//  TMT
//
//  Created by Choi Minkyeong on 11/20/24.
//

import SwiftUI

struct BusStopDetailView: View {
    var isEndStopViewVisible: Bool
    var stopNameKorean: String
    var stopNameRomanized: String
    var stopNameTranslated: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Korean")
                .foregroundStyle(isEndStopViewVisible ? .grey200 : .grey400)
                .font(.system(size: 14, weight: .medium))
            
            Text("\(stopNameKorean)")
                .foregroundStyle(.textDefault)
                .font(isEndStopViewVisible ? .system(size: 24, weight: .bold) : .system(size: 20, weight: .bold))
            
            Text("[\(stopNameRomanized)]")
                .foregroundStyle(.grey400)
                .font(.system(size: 14, weight: .medium))
            
            Divider()
                .foregroundStyle(isEndStopViewVisible ? .grey100 : .white) // TODO: divider 색상 변경 필요
                .padding(.vertical, 9)
            
            Text("English")
                .foregroundStyle(isEndStopViewVisible ? .grey200 : .grey400)
                .font(.system(size: 14, weight: .medium))
            
            Text("\(stopNameTranslated)")
                .foregroundStyle(.textDefault)
                .font(.system(size: 20, weight: .bold))
        }
    }
}

#Preview {
    var dummy = BusStop.journeyStopDummy
    
    BusStopDetailView(
        isEndStopViewVisible : true, stopNameKorean: dummy.first!.stopNameKorean ?? "",
        stopNameRomanized: dummy.first!.stopNameRomanized ?? "",
        stopNameTranslated: dummy.first!.stopNameTranslated ?? ""
    )
}
