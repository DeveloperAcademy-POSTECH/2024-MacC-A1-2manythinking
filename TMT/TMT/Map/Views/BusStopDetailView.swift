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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Korean")
                .foregroundStyle(.grey200)
                .font(.footnote)
            Text("\(stopNameKorean)")
                .foregroundStyle(.basicBlack)
                .font(.title2)
                .fontWeight(.bold)
            Text("[\(stopNameRomanized)]")
                .foregroundStyle(.grey500)
                .font(.footnote)
            Divider()
                .foregroundStyle(.grey100)
                .padding(.vertical, 9)
            Text("English")
                .foregroundStyle(.grey200)
                .font(.footnote)
            Text("\(stopNameNaver)")
                .foregroundStyle(.grey600)
                .font(.title2)
                .fontWeight(.bold)
        }
    }
}
