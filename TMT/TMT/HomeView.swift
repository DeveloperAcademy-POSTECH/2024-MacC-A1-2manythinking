//
//  HomeView.swift
//  TMT
//
//  Created by 김유빈 on 9/29/24.
//

import SwiftUI
import PhotosUI

struct HomeView: View {
    @AppStorage("shouldShowOnboarding") var shouldShowOnboarding = true
    @StateObject private var activityManager: LiveActivityManager
    @StateObject private var journeyModel: JourneySettingModel
    @StateObject private var imageHandler: ImageHandlerModel = ImageHandlerModel()
    @StateObject private var locationManager: LocationManager
    @StateObject private var searchModel: BusSearchModel
    
    @State private var isShowingInformation = false
    @State var path: [String] = []
    
    init() {
        let searchModel = BusSearchModel()
        let journeyModel = JourneySettingModel(searchModel: searchModel)
        let activityManager = LiveActivityManager()
        
        _searchModel = StateObject(wrappedValue: searchModel)
        _journeyModel = StateObject(wrappedValue: journeyModel)
        _activityManager = StateObject(wrappedValue: activityManager)
        _locationManager = StateObject(wrappedValue: LocationManager(activityManager: activityManager, journeyModel: journeyModel))
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack(alignment: .bottom) {
                Color.brandBackground
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    NotUploadedView(path: $path)
                    Spacer()
                }
                .padding(.horizontal, 16)
                
                if isShowingInformation {
                    InformationModalView(isShowingInformation: $isShowingInformation)
                }
            }
            .toolbar {
                Button {
                    isShowingInformation = true
                } label: {
                    Image(systemName: "info.circle")
                        .foregroundStyle(.grey600)
                        .font(.system(size: 17))
                }
                .disabled(isShowingInformation)
            }
            .fullScreenCover(isPresented: $shouldShowOnboarding) {
                OnboardingView(shouldShowOnboarding: $shouldShowOnboarding)
            }
        }
        .environmentObject(locationManager)
        .environmentObject(searchModel)
        .environmentObject(activityManager)
        .environmentObject(journeyModel)
        .environmentObject(imageHandler)
    }
}
