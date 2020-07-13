//
//  PhotoAlbumViewModel.swift
//  Virtual Tourist
//
//  Created by Sukumar Anup Sukumaran on 12/07/20.
//  Copyright © 2020 TechTonic. All rights reserved.
//

import UIKit
import MapKit

class PhotoAlbumViewModel: NSObject {
    
    var dataController: DataController!
    var pin:Pins?
    weak var delegate: NewCollectionDelegate?
    var hasSelectedCell = false
    
    var changeButtonNameComp: ((Bool) -> ())?
    
    override init() {}
    
    init(dataController: DataController, pins: Pins?) {
        self.dataController = dataController
        self.pin = pins
        //self.mapView = mapView
    }
    
    func showOnTheMap(_ pin: Pins, mapView: MKMapView) {
         
         let lat = pin.latitude
         let lon = pin.longitude
         let locCoord = CLLocationCoordinate2D(latitude: lat, longitude: lon)
         let zoomSpan:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.402766391761954, longitudeDelta: 0.119873426121444)
         
         let region:MKCoordinateRegion = MKCoordinateRegion.init(center: locCoord, span: zoomSpan)
         
         let annotation = MKPointAnnotation()
         annotation.coordinate = locCoord
         
         mapView.removeAnnotations(mapView.annotations)
         mapView.addAnnotation(annotation)
        // mapView.setCenter(locCoord, animated: true)
    
         mapView.setRegion(region, animated: false)
     }
    
    
    func changeButtonName(hasSelection: Bool) {
        hasSelectedCell = hasSelection
       changeButtonNameComp?(hasSelection)
        
      
       
    }

}

extension PhotoAlbumViewModel: MKMapViewDelegate {
    
    
func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    
    let reuseId = "pin"
    
    var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
    
    if pinView == nil {
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        pinView!.canShowCallout = false
        pinView!.pinTintColor = .red
        pinView!.animatesDrop = true
    } else {
        pinView!.annotation = annotation
    }
    
    return pinView
   }
}

extension PhotoAlbumViewModel: SelectionCollectionDelegate {
    
    func delectedSelectedCell(hasSelection: Bool) {
        print("Has Selection = \(hasSelection)")
        changeButtonName(hasSelection: hasSelection)
    }
    
    
}
