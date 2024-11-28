//
//  BusStopDetailView.swift
//  TMT
//
//  Created by Choi Minkyeong on 11/20/24.
//

import SwiftUI

struct BusStopDetailView: View {
    var stopNameKorean: String
    var stopNameRomanized: String
    var stopNameNaver: String
    var isEndStopViewVisible: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Korean")
                .foregroundStyle(isEndStopViewVisible ? .grey200 : .grey400)
                .font(.footnote)
            
            Text("\(stopNameKorean)")
                .foregroundStyle(.basicBlack)
                .font(.title2)
                .fontWeight(.bold)
            
            Text("[\(stopNameRomanized)]")
                .foregroundStyle(.grey400)
                .font(.footnote)
            
            Divider()
                .foregroundStyle(isEndStopViewVisible ? .grey100 : .white) // TODO: divider 색상 변경 필요
                .padding(.vertical, 9)
            
            Text("English")
                .foregroundStyle(isEndStopViewVisible ? .grey200 : .grey400)
                .font(.footnote)
            
            Text("\(stopNameNaver)")
                .foregroundStyle(.basicBlack)
                .font(.title2)
                .fontWeight(.bold)
        }
    }
}

#Preview {
    var dummy = BusStop.journeyStopDummy
    
    BusStopDetailView(
        stopNameKorean: dummy.first!.stopNameKorean ?? "",
        stopNameRomanized: dummy.first!.stopNameRomanized ?? "",
        stopNameNaver: dummy.first!.stopNameNaver ?? "",
        isEndStopViewVisible : true
    )
}
