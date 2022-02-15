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
        uiView.showsUserLocation = true

        if !self.classes.detail.isEmpty{
            uiView.removeAnnotations(uiView.annotations)
            if self.classes.detail[0].ClassLocation[0] != -1{
                
                let destination = MKPointAnnotation()
                destination.coordinate.latitude = classes.detail[0].ClassLocation[0]
                destination.coordinate.longitude = classes.detail[0].ClassLocation[1]
                
                destination.title = classes.detail[0].Major.components(separatedBy: " ")[0] + " " + classes.detail[0].Class.components(separatedBy: " ")[0] + "-" + classes.detail[0].Section.components(separatedBy: " ")[0].replacingOccurrences(of: ":", with: "") + "\n"
                destination.subtitle = classes.detail[0].MeetingInfo + "\n\n"
                uiView.addAnnotation(destination)
                let request = MKDirections.Request()
                request.source = .forCurrentLocation()
                request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination.coordinate))
                request.transportType = .walking
                
                let directions = MKDirections(request: request)
                
                
                directions.calculate{ response, error in
                    guard let route = response?.routes.first else { return }
                    if classes.Time == 0 {
                        classes.Time = Int(route.expectedTravelTime / 60)
                    }
                    if classes.showRoute{
                        uiView.addOverlay(route.polyline)
                        uiView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: 80, left: 80, bottom: 160, right: 80),animated: true)
                    } else {
                        uiView.removeOverlays(uiView.overlays)
                        if classes.showUserLocation{
                            uiView.setRegion(MKCoordinateRegion(center: uiView.userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)), animated: true)
                        } else {
                            uiView.setRegion(MKCoordinateRegion(center: destination.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)), animated: true)
                        }
                    }
                }
            }
        }
        
        else {
            
            uiView.removeOverlays(uiView.overlays)
            uiView.removeAnnotations(uiView.annotations)
            
            if !classes.ShowClass{

                if self.classes.userClass.count != 0{
                    var zoomRect = MKMapRect.null
                    for classinfo in self.classes.userClass{
                        if classinfo.ClassLocation[0] != -1 {

                            let classlocation = MKPointAnnotation()
                            classlocation.coordinate.latitude = classinfo.ClassLocation[0]
                            classlocation.coordinate.longitude = classinfo.ClassLocation[1]
                            classlocation.title = classinfo.Major.components(separatedBy: " ")[0] + " " + classinfo.Class.components(separatedBy: " ")[0] + "-" + classinfo.Section.components(separatedBy: " ")[0].replacingOccurrences(of: ":", with: "") + "\n"
                            classlocation.subtitle = classinfo.MeetingInfo + "\n\n"
                            if uiView.annotations.map({$0.coordinate.latitude}).contains(classinfo.ClassLocation[0]) && uiView.annotations.map({$0.coordinate.longitude}).contains(classinfo.ClassLocation[1]){
                                let annotation = uiView.annotations.filter({$0.coordinate.latitude == classinfo.ClassLocation[0] && $0.coordinate.longitude == classinfo.ClassLocation[1]})[0]
                                classlocation.title! += annotation.title!!
                                classlocation.subtitle! += annotation.subtitle!!
                                uiView.removeAnnotation(annotation)
                            }
                            uiView.addAnnotation(classlocation)
                            
                            let aPoint = MKMapPoint(classlocation.coordinate)
                            let rect = MKMapRect(x: aPoint.x, y: aPoint.y, width: 0.1, height: 0.1)
                            if zoomRect.isNull{
                                zoomRect = rect
                            } else{
                                zoomRect = zoomRect.union(rect)
                            }
                        }
                    }
                    if classes.showUserLocation{
                        uiView.setRegion(MKCoordinateRegion(center: uiView.userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)), animated: true)
                    } else if zoomRect.isNull{
                        uiView.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 42.055984, longitude: -87.675171), span: MKCoordinateSpan(latitudeDelta: 0.012, longitudeDelta: 0.012)), animated: true)
                    } else {
                        uiView.setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsets(top: 100, left: 100, bottom: 100, right: 100), animated: true)
                    }
                }
                else{
                    
                    if classes.showUserLocation{
                        uiView.setRegion(MKCoordinateRegion(center: uiView.userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)), animated: true)
                    } else {
                        uiView.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 42.055984, longitude: -87.675171), span: MKCoordinateSpan(latitudeDelta: 0.012, longitudeDelta: 0.012)),
                                      animated: true)
                    }
                    
                }
            }
        }
        
        
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
 
