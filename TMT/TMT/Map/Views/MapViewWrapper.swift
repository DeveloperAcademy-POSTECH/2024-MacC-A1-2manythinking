//
//  MapViewWrapper.swift
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

struct MapViewWrapper: UIViewRepresentable {
    @ObservedObject var selectedStopManager: SelectedStopManager
    @Binding var region: MKCoordinateRegion
    @Binding var isUpdateRequested: Bool
    var coordinatesList: [Coordinate]
    var updateInterval: TimeInterval = 5
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapViewWrapper
        var timer: Timer?
        private var isUserInteractionInProgress = false
        
        init(_ parent: MapViewWrapper) {
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
        
        func updateMapRegionTimer(for mapView: MKMapView) {
            timer = Timer.scheduledTimer(withTimeInterval: parent.updateInterval, repeats: true) { [weak self] _ in
                guard let self = self else { return }
                if !isUserInteractionInProgress && !parent.selectedStopManager.isTapped {
                    mapView.setRegion(parent.region, animated: true)
                }
            }
        }
        
        func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
            isUserInteractionInProgress = true
        }
        
        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            isUserInteractionInProgress = false
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
        context.coordinator.updateMapRegionTimer(for: mapView)
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        if isUpdateRequested {
            mapView.setRegion(region, animated: true)
            DispatchQueue.main.async {
                self.isUpdateRequested = false
            }
        }
        mapView.setRegion(region, animated: true)
        mapView.removeAnnotations(mapView.annotations)
        
        let annotations = coordinatesList.enumerated().map { index, stop in
            IndexedAnnotation(
                coordinate: CLLocationCoordinate2D(latitude: stop.latitude, longitude: stop.longitude),
                index: index
            )
        }
        mapView.addAnnotations(annotations)
        if selectedStopManager.isTapped, let index = selectedStopManager.selectedIndex {
            mapView.setRegion(MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: annotations[index].coordinate.latitude, longitude: annotations[index].coordinate.longitude),
                span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
            ), animated: true)
        }
    }
}
