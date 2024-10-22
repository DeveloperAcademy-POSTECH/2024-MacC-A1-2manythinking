//
//  BusSearchView.swift
//  TMT
//
//  Created by 김유빈 on 10/15/24.
//

import SwiftUI

struct BusSearchView: View {
    @StateObject private var busStopSearchViewModel = BusStopSearchViewModel()
    @State private var tag: Int? = nil
    
    var body: some View {
        NavigationStack {
            NavigationLink(destination: MapView(busStopSearchViewModel: busStopSearchViewModel), tag: 1, selection: self.$tag) {
                EmptyView()
            }
            Button {
                self.tag = 1
                busStopSearchViewModel.searchBusStops(by: "207(기본)")
            } label: {
                Text("207번 버스")
                    .background(.white)
            }
        }
    }
}

#Preview {
    BusSearchView()
}
