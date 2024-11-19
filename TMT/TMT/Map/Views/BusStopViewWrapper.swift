//
//  BusStopViewWrapper.swift
//  TMT
//
//  Created by Choi Minkyeong on 10/24/24.
//

import SwiftUI
import MapKit

struct BusStopViewWrapper: UIViewRepresentable {
    @ObservedObject var sharedViewModel: SharedViewModel
    @Binding var region: MKCoordinateRegion
    var coordinatesList: [Coordinate]
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: BusStopViewWrapper
        
        init(_ parent: BusStopViewWrapper) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if annotation is MKUserLocation {
                let identifier = "CurrentLocation"
                var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
                
                if annotationView == nil {
                    annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                    annotationView?.canShowCallout = false
                    
                    let locationImage = UIImage(named: "MyLocation")
                    annotationView?.image = locationImage
                    annotationView?.frame.size = CGSize(width: 35, height: 35)
                } else {
                    annotationView?.annotation = annotation
                }
                return annotationView
            }
            
            let identifier = "BusStop"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = false
            } else {
                annotationView?.annotation = annotation
            }
            
            if let indexedAnnotation = annotation as? IndexedAnnotation {
                if indexedAnnotation.index == parent.sharedViewModel.selectedIndex && parent.sharedViewModel.isTapped {
                    annotationView?.image = UIImage(named: "SelectedBusStopIcon")
                    // TODO: 선택한 버스 아이콘이 가장 가운데에 가게 지도 다시 위치 잡아주기
                } else {
                    annotationView?.image = UIImage(named: "BusStopIcon")
                    // TODO: 선택한 버스 아이콘이 가장 가운데에 가게 지도 다시 위치 잡아주기
                }
                annotationView?.frame.size = CGSize(width: 35, height: 35)
                annotationView?.layer.cornerRadius = 5
            }
            return annotationView
        }
        
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            if let annotation = view.annotation as? IndexedAnnotation {
                view.image = UIImage(named: "SelectedBusStopIcon")
                view.frame.size = CGSize(width: 35, height: 35)
                view.layer.cornerRadius = 5
                parent.sharedViewModel.selectedIndex = annotation.index
                parent.sharedViewModel.isTapped = true
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .followWithHeading
        mapView.setRegion(region, animated: true)
        mapView.layoutMargins = UIEdgeInsets(top: 0.0, left: 16.75, bottom: 90, right: 0)
        mapView.mapType = .mutedStandard
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        mapView.setRegion(region, animated: true)
        mapView.removeAnnotations(mapView.annotations)
        
        let annotations = coordinatesList.enumerated().map { index, stop in
            IndexedAnnotation(
                coordinate: CLLocationCoordinate2D(latitude: stop.latitude, longitude: stop.longitude),
                index: index
            )
        }
        mapView.addAnnotations(annotations)
    }
}

final class IndexedAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var index: Int
    
    init(coordinate: CLLocationCoordinate2D, index: Int) {
        self.coordinate = coordinate
        self.index = index
    }
}

final class SharedViewModel: ObservableObject {
    @Published var isTapped: Bool = false
    @Published var selectedIndex: Int = 0
}
