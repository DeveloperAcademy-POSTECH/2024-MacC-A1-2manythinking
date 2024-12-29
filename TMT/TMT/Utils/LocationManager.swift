//
//  LocationManager.swift
//  TMT
//
//  Created by Choi Minkyeong on 10/15/24.
//

import CoreLocation
import MapKit

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 36.016082, longitude: 129.324605),
        span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
    )
    @Published var isFirstLoad = true
    @Published var userLocation: CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    @Published var thisStop: BusStop?
    @Published var remainingStops: Int = 0 {
        didSet {
            if oldValue != remainingStops {
                Task {
                    if let currentStop = thisStop {
                        await LiveActivityManager.shared.updateLiveActivity(remainingStops: remainingStops, thisStop: currentStop)
                    } else {
                        print("❌ 현재 정류장 정보가 없습니다.")
                    }
                }
            }
        }
    }
    
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var showSettingsAlert = false
    
    private let locationManager = CLLocationManager()
    private weak var journeyModel: JourneySettingModel?
    
    init(journeyModel: JourneySettingModel) {
        self.journeyModel = journeyModel
        self.thisStop = journeyModel.journeyStops.first
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        locationManager.allowsBackgroundLocationUpdates = true
    }
    
    /// 사용자 위치수집권한 받기
    func requestPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    /// 사용자가 위치수집에 동의했는지 확인하기
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        DispatchQueue.main.async {
            self.authorizationStatus = status
            if status == .denied || status == .restricted {
                self.showSettingsAlert = true
            }
        }
    }
    
    /// 사용자의 현재 위치 파악
    func findCurrentLocation() {
        if let location = locationManager.location {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            
            region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
                span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
            )
        }
    }
    
    /// 사용자의 위치 업데이트
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            DispatchQueue.main.async {
                if self.isFirstLoad {
                    self.region = MKCoordinateRegion(
                        center: location.coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
                    )
                    self.isFirstLoad = false
                }
                self.userLocation = location.coordinate
                
                let result = self.journeyModel?.updateRemainingStopsAndCurrentStop(currentLocation: self.userLocation)
                self.remainingStops = result?.remainingStops ?? 0
                self.thisStop = result?.currentStop
            }
        }
    }
    
    /// 사용자의 위치를 받아오지 못한 경우
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
}
