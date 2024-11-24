//
//  BusStopView.swift
//  TMT
//
//  Created by Choi Minkyeong on 10/15/24.
//

import SwiftUI

struct Coordinate: Identifiable {
    var id = UUID()
    var latitude: Double
    var longitude: Double
}

struct BusStopDetail {
    var endStopNameKorean: String
    var endStopNameRomanized: String
    var endStopNameNaver: String
    var remainingStops: Int?
}

struct BusStopView: View {
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var searchModel: BusSearchModel
    @EnvironmentObject var journeyModel: JourneySettingModel
    @StateObject var selectedStopManager = SelectedStopManager()
    @EnvironmentObject var activityManager: LiveActivityManager
    @EnvironmentObject var imageHandler: ImageHandlerModel
    
    @State private var coordinatesList: [Coordinate] = []
    @State private var passedStops: Int = 0
    @State private var isUpdateRequested: Bool = false
    @State private var endStopDetail: BusStopDetail = .init(endStopNameKorean: "", endStopNameRomanized: "", endStopNameNaver: "", remainingStops: 0)
    @State private var tappedStopDetail: BusStopDetail = .init(endStopNameKorean: "", endStopNameRomanized: "", endStopNameNaver: "", remainingStops: 0)
    @State private var stopOrder: Int? = 0
    @Binding var path: [String]
    
    var body: some View {
        ZStack {
            busStopViewWrapper
                .edgesIgnoringSafeArea(.vertical)
            if selectedStopManager.isTapped {
                Color.black.opacity(0.3) // TODO: 투명 배경으로 변경하기
                    .ignoresSafeArea()
                    .onTapGesture {
                        selectedStopManager.isTapped = false
                    }
                TappedStopView(stopOrder: $stopOrder, tappedStopDetail: $tappedStopDetail)
                    .offset(x: -5, y: 50)
                    .position(
                        x: UIScreen.main.bounds.width / 2,
                        y: UIScreen.main.bounds.height / 3 + 20 // 팝업 아래로 약간 이동
                    )
                
                    .transition(.scale)
                    .animation(.spring(), value: selectedStopManager.isTapped)
            }
            VStack {
                EndStopView(busStopDetail: $endStopDetail)
                    .padding(.top, 16)
                    .padding(.leading ,16)
                    .padding(.trailing, 17)
                Spacer()
                endButton // bottom sheet 적용되면 삭제될 예정
                HStack {
                    Spacer()
                    controlsView
                        .padding(.trailing, 28)
                        .padding(.bottom, 19.64)
                }
            }
        }
        .environmentObject(selectedStopManager)
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            if locationManager.isFirstLoad {
                locationManager.findCurrentLocation()
            }
            searchModel.searchBusStops(byNumber: journeyModel.journeyStops.first?.busNumber ?? "")
            coordinatesList = getValidCoordinates()
            endStopDetail = BusStopDetail(endStopNameKorean: journeyModel.journeyStops.last?.stopNameKorean ?? "", endStopNameRomanized: journeyModel.journeyStops.last?.stopNameRomanized ?? "", endStopNameNaver: journeyModel.journeyStops.last?.stopNameNaver ?? "", remainingStops: locationManager.remainingStops)
        }
        .onChange(of: locationManager.remainingStops) {
            passedStops = journeyModel.journeyStops.count - locationManager.remainingStops
        }
    }
    
    private var busStopViewWrapper: some View {
        BusStopViewWrapper(selectedStopManager: selectedStopManager, region: $locationManager.region, isUpdateRequested: $isUpdateRequested, coordinatesList: coordinatesList)
    }
    
    private var controlsView: some View {
        Button {
            locationManager.findCurrentLocation()
            isUpdateRequested = true
        } label: {
            Image(systemName: "location.fill")
                .foregroundStyle(.yellow500)
                .background {
                    Circle()
                        .frame(width: 44, height: 44)
                        .foregroundStyle(.basicWhite)
                        .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 2)
                }
        }
    }
    
    // 임의로 버튼을 만들어 놓았습니다. 추후 bottom sheet에 적용될 예정입니다.
    private var endButton: some View {
        Button {
            activityManager.endLiveActivity()
            imageHandler.selectedImage = nil
            path.removeAll()
        } label: {
            Text("End")
                .foregroundStyle(.basicWhite)
                .frame(width: 69, height: 38)
                .background {
                    RoundedRectangle(cornerRadius: 30)
                        .foregroundStyle(.brandPrimary)
                }
        }
    }
    
    /// 좌표의 옵셔널을 제거합니다.
    private func getValidCoordinates() -> [Coordinate] {
        searchModel.filteredBusDataForNumber.compactMap { stop in
            guard let latitude = stop.latitude,
                  let longitude = stop.longitude else {
                return nil
            }
            return Coordinate(latitude: latitude, longitude: longitude)
        }
    }
    
    private func updateStateOrder() {
        stopOrder = selectedStopManager.selectedIndex
    }
}
