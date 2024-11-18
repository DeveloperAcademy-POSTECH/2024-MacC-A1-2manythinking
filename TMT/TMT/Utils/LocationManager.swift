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
    
    @Published var remainingStops: Int = 0 {
        didSet {
            if oldValue != remainingStops {
                Task {
                    await activityManager?.updateLiveActivity(remainingStops: remainingStops)
                }
            }
        }
    }
    
    private let locationManager = CLLocationManager()
    private weak var activityManager: LiveActivityManager?
    private weak var journeyModel: JourneySettingModel?
    
    init(activityManager: LiveActivityManager, journeyModel: JourneySettingModel) {
        self.activityManager = activityManager
        self.journeyModel = journeyModel
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.allowsBackgroundLocationUpdates = true
    }
    
    /// 사용자의 현재 위치 파악
    func findCurrentLocation() {
        if let location = locationManager.location {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            
            region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: latitude + 0.001, longitude: longitude),
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
                
                self.remainingStops = self.journeyModel?.updateRemainingStops(currentLocation: self.userLocation) ?? 0
            }
        }
    }
    
    /// 사용자의 위치를 받아오지 못한 경우
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
}
