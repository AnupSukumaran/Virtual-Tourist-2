//
//  TravelLocationsMapViewModel.swift
//  Virtual Tourist
//
//  Created by Sukumar Anup Sukumaran on 29/06/20.
//  Copyright © 2020 TechTonic. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class TravelLocationsMapViewModel: NSObject {
    
    var dataController: DataController!
   // var mapView: MKMapView!
    var pins: [Pins] = []
    var pinAnnotations = [MKPointAnnotation]()
    var pinAnnotation: MKPointAnnotation? = nil
    var isEdititng = false
    
    override init() {}
    
    init(dataController: DataController) {
        self.dataController = dataController
        //self.mapView = mapView
    }
    
    func callingInitialMapState(mapView: MKMapView) {
        if let lat = UserDefaults.standard.value(forKey: Constants.lat) as? Double , let long = UserDefaults.standard.value(forKey: Constants.long) as? Double, let zlat = UserDefaults.standard.value(forKey: Constants.zlat) as? Double, let zLong = UserDefaults.standard.value(forKey: Constants.zLong) as? Double  {
            
            setMapLocation(latitude: lat, longitude: long, zLatitude: zlat, zLongitude: zLong, mapView: mapView)
        } else {
            print("Failed")
        }
    }
    
    func setMapLocation( latitude: CLLocationDegrees, longitude: CLLocationDegrees, zLatitude: CLLocationDegrees, zLongitude: CLLocationDegrees, mapView: MKMapView){
        
        let zoomSpan:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: zLatitude, longitudeDelta: zLongitude)
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        let region:MKCoordinateRegion = MKCoordinateRegion.init(center: location, span: zoomSpan)
        mapView.setRegion(region, animated: false)
        
    }
    
    func fetchRequest(mapView: MKMapView) {
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
    
    func EditingAction(comp: (Bool) -> ()) {
        isEdititng = !isEdititng
        comp(isEdititng)

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
    
    
    func saveLocationDataAsMapMoves(_ mapV: MKMapView) {
        let zoom = mapV.region.span
        let center = mapV.centerCoordinate
        
        let zlat = zoom.latitudeDelta as Double
        let zLong = zoom.longitudeDelta as Double
        
        let lat = center.latitude as Double
        let long = center.longitude as Double
        
        UserDefaults.standard.set(lat, forKey: "lat")
        UserDefaults.standard.set(long, forKey: "long")
        UserDefaults.standard.set(zlat, forKey: "zlat")
        UserDefaults.standard.set(zLong, forKey: "zLong")
    }
    
    func settingUpPinView(mapV: MKMapView, annotation: MKAnnotation, pinColor: UIColor = .red) -> MKPinAnnotationView?  {
        
        let reuseId = "pin"
        
        var pinView = mapV.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = false
            pinView!.pinTintColor = pinColor
            pinView!.animatesDrop = true
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func getAnnotaionsOrLocModel(view: MKAnnotationView, mapView: MKMapView) -> (annotation: MKAnnotation, locModel: LocModel)? {
        guard let annotation = view.annotation else {return nil}
         let zoom = mapView.region.span
        
         let lat = annotation.coordinate.latitude
         let lon = annotation.coordinate.longitude
         
         let locModel = LocModel(lat: lat, lon: lon, zLat: zoom.latitudeDelta, zLong: zoom.longitudeDelta)
        
        return (annotation, locModel)
    }
    
    func removePins(mv:MKMapView) {
        let selectedAnnotations = mv.selectedAnnotations
        selectedAnnotations.forEach { mv.deselectAnnotation($0, animated: true)}
    }
    
    func loadPinsFromCoreAndDeleteThemAndSaveChanges(mv:MKMapView, annotation: MKAnnotation) {
        mv.removeAnnotation(annotation)

         if let pin = loadPin(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude) {
        
             dataController.viewContext.delete(pin)
             saved()

         } else {
             print("Not returning pins")
         }

    }

}
