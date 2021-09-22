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

struct MapView: UIViewRepresentable {

    typealias UIViewType = MKMapView
    @EnvironmentObject var classes: ClassLocations
    
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
        if self.classes.showRoute{
            let destination = MKPointAnnotation()
            destination.coordinate = CLLocationCoordinate2D(latitude: classes.detail.first?.ClassLocation[0] ?? -1, longitude: self.classes.detail.first?.ClassLocation[1] ?? -1)
            let request = MKDirections.Request()
            
            request.source = .forCurrentLocation()
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination.coordinate))
            request.transportType = .walking
            
            let directions = MKDirections(request: request)
            
            directions.calculate{ response, error in
                guard let route = response?.routes.first else { return }
                self.classes.time = route.expectedTravelTime / 60
                uiView.addOverlay(route.polyline)
                uiView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: 80, left: 80, bottom: 160, right: 80),animated: true)
            }
        }
        
        else{
            uiView.removeOverlays(uiView.overlays)
            uiView.removeAnnotations(uiView.annotations)
            if self.classes.classlocations.count != 0{
                var zoomRect = MKMapRect.null
                for annotations in classes.classlocations{
                    let aPoint = MKMapPoint(annotations.coordinate)
                    let rect = MKMapRect(x: aPoint.x, y: aPoint.y, width: 0.1,height: 0.1)
                    if zoomRect.isNull {
                        zoomRect = rect
                    } else {
                        zoomRect = zoomRect.union(rect)
                    }
                }
                uiView.setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsets(top: 100, left: 100, bottom: 100, right: 100), animated: true)
                uiView.addAnnotations(self.classes.classlocations)
            }
            else{
                uiView.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 42.055984, longitude: -87.675171), span: MKCoordinateSpan(latitudeDelta: 0.012, longitudeDelta: 0.012)),
                              animated: true)
            }
        }
        
    }
    
    func setCenter(_ uiView: MKMapView){
        var zoomRect = MKMapRect.null
        for annotations in classes.classlocations{
            let aPoint = MKMapPoint(annotations.coordinate)
            let rect = MKMapRect(x: aPoint.x, y: aPoint.y, width: 0,height: 0)
            
            if zoomRect.isNull {
                zoomRect = rect
            } else {
                zoomRect = zoomRect.union(rect)
            }
        }
        uiView.removeOverlays(uiView.overlays)
        uiView.removeAnnotations(uiView.annotations)
        uiView.addAnnotations(self.classes.classlocations)
        uiView.showAnnotations(uiView.annotations, animated: true)
        uiView.setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsets(top: 100, left: 100, bottom: 100, right: 100), animated: true)
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
 
