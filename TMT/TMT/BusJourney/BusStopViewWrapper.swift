//
//  MapViewWrapper.swift
//  TMT
//
//  Created by Choi Minkyeong on 10/24/24.
//

import SwiftUI
import MapKit

struct BusStopViewWrapper: UIViewRepresentable {
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
                    annotationView?.canShowCallout = true
                    
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
                annotationView?.canShowCallout = true
                let busStopImage = UIImage(named: "busStopIcon")
                annotationView?.image = busStopImage
                annotationView?.frame.size = CGSize(width: 35, height: 35)
                annotationView?.layer.cornerRadius = 5
            } else {
                annotationView?.annotation = annotation
            }
            return annotationView
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
        
        let annotations = coordinatesList.map { stop in
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: stop.latitude, longitude: stop.longtitude)
            return annotation
        }
        mapView.addAnnotations(annotations)
    }
}
