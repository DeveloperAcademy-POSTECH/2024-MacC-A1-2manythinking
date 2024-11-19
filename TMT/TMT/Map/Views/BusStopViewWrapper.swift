//
//  BusStopViewWrapper.swift
//  TMT
//
//  Created by Choi Minkyeong on 10/24/24.
//

import SwiftUI
import MapKit

final class IndexedAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var index: Int
    
    init(coordinate: CLLocationCoordinate2D, index: Int) {
        self.coordinate = coordinate
        self.index = index
    }
}

final class SelectedStopManager: ObservableObject {
    @Published var isTapped: Bool = false
    @Published var selectedIndex: Int? = 0
}

struct BusStopViewWrapper: UIViewRepresentable {
    @ObservedObject var selectedStopManager: SelectedStopManager
    @Binding var region: MKCoordinateRegion
    @Binding var isUpdateRequested: Bool
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
                if indexedAnnotation.index == parent.selectedStopManager.selectedIndex && parent.selectedStopManager.isTapped {
                    annotationView?.image = UIImage(named: "SelectedBusStopIcon")
                } else {
                    annotationView?.image = UIImage(named: "BusStopIcon")
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
                parent.selectedStopManager.selectedIndex = annotation.index
                parent.selectedStopManager.isTapped = true
                mapView.setRegion(MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude),
                    span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
                ), animated: true)
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
        if isUpdateRequested {
            mapView.setRegion(region, animated: true)
            DispatchQueue.main.async {
                isUpdateRequested = false
            }
        }
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
