//
//  CommonFunctions.swift
//  Virtual Tourist
//
//  Created by Sukumar Anup Sukumaran on 10/09/18.
//  Copyright © 2018 TechTonic. All rights reserved.
//

import Foundation
import MapKit
import CoreData

class CommonFunc: NSObject {
    
    static let shared = CommonFunc()
    var pinAnnotations = [MKPointAnnotation]()
    var pinAnnotation: MKPointAnnotation? = nil
    var dataController: DataController!
    var pins: [Pins] = []
    
    var galleryModel = [GalleryModel]()
    
    func callingInitialMapState( mapView: MKMapView) {
        if let lat = UserDefaults.standard.value(forKey: Constants.lat) as? Double , let long = UserDefaults.standard.value(forKey: Constants.long) as? Double, let zlat = UserDefaults.standard.value(forKey: Constants.zlat) as? Double, let zLong = UserDefaults.standard.value(forKey: Constants.zLong) as? Double  {
            
            setMapLocation(mapView: mapView, latitude: lat, longitude: long, zLatitude: zlat, zLongitude: zLong)
        } else {
            print("Failed")
        }
    }
    
    func setMapLocation( mapView: MKMapView, latitude: CLLocationDegrees, longitude: CLLocationDegrees, zLatitude: CLLocationDegrees, zLongitude: CLLocationDegrees){
        
        let zoomSpan:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: zLatitude, longitudeDelta: zLongitude)
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        let region:MKCoordinateRegion = MKCoordinateRegion.init(center: location, span: zoomSpan)
        mapView.setRegion(region, animated: false)
        
    }
    
    func fetchRequest(selfClass: AnyObject, mapView: MKMapView) {
       // let vc = selfClass as! TravelLocationsMapViewController
        
        let fetchRequest: NSFetchRequest<Pins> = Pins.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "latitude", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        if let results = try? dataController.viewContext.fetch(fetchRequest) {
            pins = results
            createAnnotations(pins: pins, mapView: mapView)
        }
    }
    
    func createAnnotations(pins:[Pins], mapView: MKMapView) {
        
        for dict in pins {
            
            let lat = CLLocationDegrees(dict.latitude )
            let long = CLLocationDegrees(dict.longitude )
            
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            
            self.pinAnnotations.append(annotation)
            
        }
        
            mapView.addAnnotations(pinAnnotations)
        
    }
    
   
    
    func callingPinToDrop(_ sender: UILongPressGestureRecognizer, mapView: MKMapView) {
        
        let location = sender.location(in: mapView)
        let locCoord = mapView.convert(location, toCoordinateFrom: mapView)
        
        if sender.state == .began {
            
            pinAnnotation = MKPointAnnotation()
            pinAnnotation!.coordinate = locCoord
            
           
            
            mapView.addAnnotation(pinAnnotation!)
            
        } else if sender.state == .changed {
            pinAnnotation!.coordinate = locCoord
        } else if sender.state == .ended {
            
            let pin = Pins(context: dataController.viewContext)
            pin.latitude = locCoord.latitude
            pin.longitude = locCoord.longitude
            
            saved()
            
            
        }
    }
    
    func loadPin(latitude: Double, longitude: Double) -> Pins? {
        
        var pin: Pins?
        
        let fetchRequest: NSFetchRequest<Pins> = Pins.fetchRequest()
        let predicate = NSPredicate(format: "latitude == %lf AND longitude == %lf", latitude, longitude)
        
        fetchRequest.predicate = predicate
        
        do {
            let results = try dataController.viewContext.fetch(fetchRequest)
            
            pin = results.first
            
            return pin
        } catch let error {
            print("Error = \(error.localizedDescription)")
            return nil
        }
        
        
    }
    
    func saved() {
        if dataController.viewContext.hasChanges {
            do{
                try dataController.viewContext.save()
                
                print("Saved Pin😛")
            }catch let error{
                print(" Error😩 = \(error.localizedDescription)")
            }
        } else {
            print("No Changes in nsmanagedobjectcontext")
        }
        
    }
    
}


