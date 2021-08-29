//
//  AninimatedMapView.swift
//  Salad Project
//
//  Created by Yunfan Yang on 8/26/21.
//

import Foundation
import SwiftUI
import MapKit
import UIKit

/*
struct AnimatedMapView : UIViewRepresentable{
    
    typealias UIViewType = MKMapView
    
    func makeUIView(context: Context) -> MKMapView {
        
        
        
        let map = MKMapView()
        map.showsUserLocation = true
        map.delegate = context.coordinator
        map.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 42.054, longitude: -87.675), span: MKCoordinateSpan(latitudeDelta: 0.012, longitudeDelta: 0.012)), animated: true)
        let p1 = MKPointAnnotation()
        p1.coordinate = CLLocationCoordinate2D(latitude: 42.054, longitude: -87.675)
        p1.title = "Your Location"
        let p2 = MKPointAnnotation()
        p2.coordinate = CLLocationCoordinate2D(latitude: 42.054, longitude: -87.685)
        p2.title = "IEMS313"
        p2.subtitle = "Tech M128"
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: p1.coordinate))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: p2.coordinate))
        request.transportType = .walking
        
        let directions = MKDirections(request: request)
        directions.calculate{ response, error in
            guard let route = response?.routes.first else {return}
            map.addAnnotations([p1,p2])
            map.addOverlay(route.polyline)
            map.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: 80, left: 80, bottom: 160, right: 80),animated: true)
        }
        
        return map
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        //do nothing
    }
    
    func makeCoordinator() -> MapViewCoordinator {
        return MapViewCoordinator()
    }
    
    
    
   
    
    
    class MapViewCoordinator: NSObject, MKMapViewDelegate{
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKPolylineRenderer(overlay: overlay)
                
            renderer.strokeColor = UIColor(Color(#colorLiteral(red: 0.4745098039, green: 0.768627451, blue: 0.5843137255, alpha: 1)))
            renderer.lineWidth = 8
            
            return renderer
        }
    }
}
 */








