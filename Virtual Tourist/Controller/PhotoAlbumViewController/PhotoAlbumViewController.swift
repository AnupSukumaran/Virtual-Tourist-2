//
//  PhotoAlbumViewController.swift
//  Virtual Tourist
//
//  Created by Sukumar Anup Sukumaran on 10/09/18.
//  Copyright © 2018 TechTonic. All rights reserved.
//

import UIKit
import CoreData
import MapKit

protocol NewCollectionDelegate: class {
    func clearForNewCollection()
    func deleteSelectedCell()
}

class PhotoAlbumViewController: UIViewController {
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var newCollectionButton: UIButton!
    
    var locModel: LocModel?
    
//    var lat: Double?
//    var long: Double?
//    var zlat: Double?
//    var zlong: Double?
    
    var dataController: DataController!// = CommonFunc.shared.dataController
    let sharedFunc = CommonFunc.shared
    var pin:Pins?
    weak var delegate: NewCollectionDelegate?
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        
        mapView.isZoomEnabled = false
        mapView.isScrollEnabled = false
        
        if let pin = pin {
            showOnTheMap(pin)
        } else {print(" Pin not found 😩");return}
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
    }
    
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
      
    }
    
    private func showOnTheMap(_ pin: Pins) {
        
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
    
    var hasSelectedCell = false
    func changeButtonName(hasSelection: Bool) {
        
        if hasSelection {
            self.hasSelectedCell = hasSelection
            self.newCollectionButton.setTitle("Remove Selected Pictures", for: .normal)
        } else {
            self.hasSelectedCell = hasSelection
            self.newCollectionButton.setTitle("New Collection", for: .normal)
        }
        
    }

    
    @IBAction func newCollection(_ sender: Any) {
        print("callingDelegate")
        if hasSelectedCell {
            delegate?.deleteSelectedCell()
        } else {
            delegate?.clearForNewCollection()
        }
        
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
 
            let vc = segue.destination as! PhotosCollectionViewController
                vc.dataController = dataController
                vc.pin = pin
                vc.photoAlbum = self
                vc.delegate = self
        
    }
    

}

extension PhotoAlbumViewController: MKMapViewDelegate {
    
    
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

extension PhotoAlbumViewController: SelectionCollectionDelegate {
    
    func delectedSelectedCell(hasSelection: Bool) {
        print("Has Selection = \(hasSelection)")
        changeButtonName(hasSelection: hasSelection)
    }
    
    
}

