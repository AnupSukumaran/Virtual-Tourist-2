//
//  TravelLocationsMapViewController.swift
//  Virtual Tourist
//
//  Created by Sukumar Anup Sukumaran on 09/09/18.
//  Copyright © 2018 TechTonic. All rights reserved.
//

import UIKit
import MapKit
//import CoreData

class TravelLocationsMapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
  
    var dataController: DataController!
    var isEdititng = false
    let sharedFunc = CommonFunc.shared
    
    @IBOutlet weak var EditButton: UIBarButtonItem!
    @IBOutlet weak var EditView: UIView!
    @IBOutlet var longPressGestures: UILongPressGestureRecognizer!
    

    

    override func viewDidLoad() {
        super.viewDidLoad()
        EditButton.title = "Edit"
        sharedFunc.dataController = dataController
        sharedFunc.callingInitialMapState(mapView: mapView)
        sharedFunc.fetchRequest(selfClass: self, mapView: mapView)
        
    }
    
    
  

    
    @IBAction func AddPinsAction(_ sender: UILongPressGestureRecognizer) {
        
       // callingPinToDrop(sender)
        sharedFunc.callingPinToDrop(sender, mapView: mapView)
    }
    
    
    
    fileprivate func EditingAction() {
        isEdititng = !isEdititng
        var tempY:CGFloat = 0.0
        if isEdititng{
            EditButton.title = "Done"
            tempY = self.mapView.bounds.origin.y
            UIView.animate(withDuration: 0.2) {
                self.mapView.bounds.origin.y = self.EditView.frame.height
                self.longPressGestures.isEnabled = false
            }
            
        } else {
            EditButton.title = "Edit"
            UIView.animate(withDuration: 0.2) {
                self.mapView.bounds.origin.y = tempY
                self.longPressGestures.isEnabled = true
            }
            
        }
    }
    
    @IBAction func EditingAction(_ sender: UIBarButtonItem) {
        EditingAction()
    
    }
    
    

}


extension TravelLocationsMapViewController: MKMapViewDelegate {
    
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        let zoom = mapView.region.span
        let center = mapView.centerCoordinate
        
        let zlat = zoom.latitudeDelta as Double
        let zLong = zoom.longitudeDelta as Double
        
        let lat = center.latitude as Double
        let long = center.longitude as Double
        
        UserDefaults.standard.set(lat, forKey: "lat")
        UserDefaults.standard.set(long, forKey: "long")
        UserDefaults.standard.set(zlat, forKey: "zlat")
        UserDefaults.standard.set(zLong, forKey: "zLong")

    }
    
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
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("selecting")
        guard let annotation = view.annotation else {return}
        let zoom = mapView.region.span
       
        let lat = annotation.coordinate.latitude
        let lon = annotation.coordinate.longitude
        
        let dataDict = ["lat": lat, "long": lon, "zLat": zoom.latitudeDelta, "zLong": zoom.longitudeDelta] as JSON
        if isEdititng{
             mapView.removeAnnotation(annotation)
            if let pin = sharedFunc.loadPin(latitude: lat, longitude: lon) {
                sharedFunc.dataController.viewContext.delete(pin)
                
                sharedFunc.saved()
                
                
                
            } else {
                print("Not returning pins")
            }
            
        } else {
            print("non-editing mode")
            performSegue(withIdentifier: "showVC", sender: dataDict)
        }
       
         let selectedAnnotations = mapView.selectedAnnotations
        let _ = selectedAnnotations.map{mapView.deselectAnnotation($0, animated: true)}
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let backItem = UIBarButtonItem()
        backItem.title = "OK"
        navigationItem.backBarButtonItem = backItem
        
        if let dict = sender as? JSON {
        print("dict = \(dict)")
            if segue.identifier == "showVC" {
                let vc = segue.destination as! PhotoAlbumViewController
                vc.lat = dict["lat"] as? Double
                vc.long = dict["long"] as? Double
                vc.zlat = dict["zLat"] as? Double
                vc.zlong = dict["zLong"] as? Double
                if let pin = sharedFunc.loadPin(latitude: dict["lat"] as! Double, longitude: dict["long"] as! Double) {
                    vc.pin = pin
                    //vc.dataController = dataController
                }
                
                
            }
        } else {print("Failed Casting")}
    }
    
}

