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
}

class PhotoAlbumViewController: UIViewController {
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    
//    @IBOutlet weak var collectionViewer: UICollectionView!
//    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var lat: Double?
    var long: Double?
    var zlat: Double?
    var zlong: Double?
    
    var dataController: DataController = CommonFunc.shared.dataController
    let sharedFunc = CommonFunc.shared
    var pin:Pins!
    weak var delegate: NewCollectionDelegate?
    
    
//    var fetchResultsController: NSFetchedResultsController<Photo>!
//
//    var selectedIndexes = [IndexPath]()
//    var insertedIndexPaths: [IndexPath]!
//    var deletedIndexPaths: [IndexPath]!
//    var updatedIndexPaths: [IndexPath]!
//
    
    override func viewDidLoad() {
        super.viewDidLoad()
     //   updateFlowLayout(view.frame.size)
       
//        CommonFunc.shared.setMapLocation(mapView: mapView, latitude: lat ?? 0.0, longitude: long ?? 0.0, zLatitude: zlat ?? 0.0, zLongitude: zlong ?? 0)
//        if let photos = pin.photos, photos.count == 0 {
//            callingAPI(pin: pin)
//        }
//        mapView.delegate = self
        mapView.isZoomEnabled = false
        mapView.isScrollEnabled = false
        showOnTheMap(pin)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      //  setupFetchResultsControllerMethod()
      //   setupFetchedResultControllerWith(pin)
    }
    
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
      //  fetchResultsController = nil
    }
    
    private func showOnTheMap(_ pin: Pins) {
        
        let lat = pin.latitude
        let lon = pin.longitude
        let locCoord = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = locCoord
        
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(annotation)
        mapView.setCenter(locCoord, animated: true)
    }
    

    
    @IBAction func newCollection(_ sender: Any) {
        print("callingDelegate")
        delegate?.clearForNewCollection()
//        let _ = fetchResultsController.fetchedObjects!.map{ sharedFunc.dataController.viewContext.delete($0)}
//        sharedFunc.saved()
//        callingAPI(pin: pin)
//
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Segued")
        if segue.identifier == "segue1" {
            let vc = segue.destination as! PhotosCollectionViewController
            vc.dataController = dataController
            vc.pin = pin
            vc.photoAlbum = self
        }
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

