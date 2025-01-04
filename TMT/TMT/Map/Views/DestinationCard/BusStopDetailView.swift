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
                .label1Medium()
                .foregroundStyle(isEndStopViewVisible ? .grey200 : .grey400)

            Text("\(stopNameKorean)")
                .font(isEndStopViewVisible ? .custom("Pretendard", size: 24).bold() : .custom("Pretendard", size: 20).bold())
                .foregroundStyle(.textDefault)

            Text("[\(stopNameRomanized)]")
                .label1Medium()
                .foregroundStyle(.grey400)

            Divider()
                .background(isEndStopViewVisible ? .busStopLine : .grey100)
                .padding(.vertical, 9)
            
            Text("English")
                .label1Medium()
                .foregroundStyle(isEndStopViewVisible ? .grey200 : .grey400)

            Text("\(stopNameTranslated)")
                .title4()
                .foregroundStyle(.textDefault)
        }
    }
}

#Preview {
    var dummy = BusStop.journeyStopDummy
    
    BusStopDetailView(
        isEndStopViewVisible : true, stopNameKorean: dummy.first!.stopNameKorean ?? "",
        stopNameRomanized: dummy.first!.stopNameRomanized ?? "",
        stopNameTranslated: dummy.first!.stopNameTranslated ?? "Jong-gak Station"
    )
    .padding(.bottom, 50)

    BusStopDetailView(
        isEndStopViewVisible : false, stopNameKorean: dummy.first!.stopNameKorean ?? "",
        stopNameRomanized: dummy.first!.stopNameRomanized ?? "",
        stopNameTranslated: dummy.first!.stopNameTranslated ?? "Jong-gak Station"
    )
}
