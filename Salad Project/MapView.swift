//
//  FinalMapView.swift
//  Salad Project
//
//  Created by Yunfan Yang on 8/27/21.
//

import Foundation
import MapKit
import SwiftUI
import UIKit

class Coordinator: NSObject, MKMapViewDelegate{
    
    var control: MapView
    
    init(_ control: MapView) {
        self.control = control
    }
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]){
        if let annotationView = views.first {
            if let annotation = annotationView.annotation{
                if annotation is MKUserLocation {
                    let region = MKCoordinateRegion(center: annotation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.012, longitudeDelta: 0.012))
                    mapView.setRegion(region, animated: true)
                }
            }
        }
    }
}



struct MapView: UIViewRepresentable {

    typealias UIViewType = MKMapView
    @Binding var coordinate: [Double]
    @Binding var classes: [MKPointAnnotation]
    @Binding var show: Bool
    
    func makeCoordinator() -> MapViewCoordinator{
        return MapViewCoordinator()
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let map = MKMapView()
        map.showsUserLocation = false
        map.delegate = context.coordinator
        map.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 42.055984, longitude: -87.675171), span: MKCoordinateSpan(latitudeDelta: 0.012, longitudeDelta: 0.012)),
                      animated: true)
        return map
    }
    
    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<MapView>) {
        uiView.removeAnnotations(uiView.annotations)
        uiView.showsUserLocation = true
        
        if show{
            
            let destination = MKPointAnnotation()
            destination.coordinate = CLLocationCoordinate2D(latitude: coordinate[0], longitude: coordinate[1])
            destination.title = "IEMS313"
            destination.subtitle = "Tech M128"
            uiView.addAnnotation(destination)
            let request = MKDirections.Request()
            request.source = .forCurrentLocation()
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination.coordinate))
            request.transportType = .walking
            
            let directions = MKDirections(request: request)
            directions.calculate{ response, error in
                guard let route = response?.routes.first else {return}
                uiView.addOverlay(route.polyline)
                uiView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: 80, left: 80, bottom: 160, right: 80),animated: true)
            }
        }
        else{
            uiView.removeOverlays(uiView.overlays)
            uiView.removeAnnotations(uiView.annotations)
            uiView.addAnnotations(classes)
            uiView.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 42.055984, longitude: -87.675171), span: MKCoordinateSpan(latitudeDelta: 0.012, longitudeDelta: 0.012)),
                             animated: true)
        }
        
        
        
        
    }
    
    func updateAnnotations(from mapView: MKMapView){
        
    }
    
    class MapViewCoordinator: NSObject, MKMapViewDelegate{
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor(Color(#colorLiteral(red: 0.4745098039, green: 0.768627451, blue: 0.5843137255, alpha: 1)))
            renderer.lineWidth = 8
            renderer.lineCap = .round
            return renderer
        }
    }
}
 
