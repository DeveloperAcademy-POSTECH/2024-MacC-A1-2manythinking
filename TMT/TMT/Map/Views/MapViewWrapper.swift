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
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @ObservedObject var selectedStopManager: SelectedStopManager
    
    @Binding var isUpdateRequested: Bool
    @Binding var region: MKCoordinateRegion
    
    var busStopCoordinates: [BusStop]
    var busRouteCoordinates: [Coordinate]
    var updateInterval: TimeInterval = 5
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapViewWrapper
        var screenMode: String
        var timer: Timer?
        private var isUserInteractionInProgress = false
        
        init(_ parent: MapViewWrapper, colorScheme: ColorScheme) {
            self.parent = parent
            self.screenMode = colorScheme == .dark ? "Dark" : "Light"
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
                    annotationView?.frame.size = CGSize(width: 30, height: 30)
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
                    if screenMode == "Light" {
                        annotationView?.image = UIImage(named: "SelectedBusStopIcon")
                    } else {
                        annotationView?.image = UIImage(named: "SelectedBusStopIconDark")
                    }
                } else {
                    if screenMode == "Light" {
                        annotationView?.image = UIImage(named: "BusStopIcon")
                    } else {
                        annotationView?.image = UIImage(named: "BusStopIconDark")
                    }
                }
                annotationView?.frame.size = CGSize(width: 25, height: 25)
            }
            return annotationView
        }
        
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            if let annotation = view.annotation as? IndexedAnnotation {
                view.image = UIImage(named: "SelectedBusStopIcon")
                view.frame.size = CGSize(width: 25, height: 25)
                
                parent.selectedStopManager.selectedIndex = annotation.index
                parent.selectedStopManager.isTapped = true
                
                mapView.setRegion(MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude),
                    span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
                ), animated: true)
            }
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = .yellow500
                renderer.lineWidth = 10.0
                return renderer
            }
            return MKOverlayRenderer()
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
        Coordinator(self, colorScheme: colorScheme)
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .followWithHeading
        mapView.setRegion(region, animated: true)
        mapView.layoutMargins = UIEdgeInsets(top: 0.0, left: 0, bottom: 0, right: 0)
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
        
        let annotations = busStopCoordinates.enumerated().map { index, stop in
            IndexedAnnotation(
                coordinate: CLLocationCoordinate2D(latitude: stop.latitude ?? 0, longitude: stop.longitude ?? 0),
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
        
        let coordinates = busRouteCoordinates.map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }
        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        mapView.addOverlay(polyline)
    }
}
