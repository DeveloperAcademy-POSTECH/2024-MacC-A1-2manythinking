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
    var viewType: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Korean")
                .foregroundStyle(viewType == "EndStopView" ? .grey200 : .grey400)
                .font(.footnote)
            
            Text("\(stopNameKorean)")
                .foregroundStyle(.basicBlack)
                .font(.title2)
                .fontWeight(.bold)
            
            Text("[\(stopNameRomanized)]")
                .foregroundStyle(.grey400)
                .font(.footnote)
            
            Divider()
                .foregroundStyle(viewType == "EndStopView" ? .grey100 : .white) // TODO: white 변경 필요
                .padding(.vertical, 9)
            
            Text("English")
                .foregroundStyle(viewType == "EndStopView" ? .grey200 : .grey400)
                .font(.footnote)
            
            Text("\(stopNameNaver)")
                .foregroundStyle(.grey600)
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
        stopNameNaver: dummy.first!.stopNameNaver ?? ""
    )
}
