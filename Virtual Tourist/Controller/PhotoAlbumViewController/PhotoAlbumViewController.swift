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
    
//    func setMapLocation( _ pin: Pins, zLatitude: CLLocationDegrees, zLongitude: CLLocationDegrees){
//        
//        let zoomSpan:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: zLatitude, longitudeDelta: zLongitude)
//        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(pin.latitude, pin.longitude)
//        let region:MKCoordinateRegion = MKCoordinateRegionMake(location, zoomSpan)
//        
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = location
//        mapView.removeAnnotations(mapView.annotations)
//        mapView.addAnnotation(annotation)
//        mapView.setRegion(region, animated: false)
//        
//    }
    
    
//    private func setupFetchedResultControllerWith(_ pin: Pins) {
//        print("setuping --FetchedResultControllerWith")
//        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
//        let predicate = NSPredicate(format: "pin == %@", pin)
//        fetchRequest.predicate = predicate
//        let sortDescriptor = NSSortDescriptor(key: "imageUrl", ascending: false)
//        fetchRequest.sortDescriptors = [sortDescriptor]
//
//        // Create the FetchedResultsController
//        fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CommonFunc.shared.dataController.viewContext, sectionNameKeyPath: nil, cacheName: "\(pin.latitude)")
//        fetchResultsController.delegate = self
//
//
//
//        // Start the fetched results controller
//        var error: NSError?
//        do {
//            print("fetching data")
//            try fetchResultsController.performFetch()  //2
//        } catch let error1 as NSError {
//            print("Error while fetching")
//            error = error1
//        }
//
//        if let error = error {
//            print("CoreData 😒Error performing initial fetch: \(error)")
//        }
//
//        print("DoneFetchingFunc")
//
//    }
//
//     func setupFetchResultsControllerMethod() {
//        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
//        let predicate = NSPredicate(format: "pin == %@", pin)
//        fetchRequest.predicate = predicate
//        let sortDescriptor = NSSortDescriptor(key: "image", ascending: false)
//        fetchRequest.sortDescriptors = [sortDescriptor]
//
//        fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: sharedFunc.dataController.viewContext, sectionNameKeyPath: nil, cacheName: "\(pin.latitude)")
//
//        fetchResultsController.delegate = self
//
//        do {
//            try fetchResultsController.performFetch()
//        } catch let error {
//
//            print("Error = \(error.localizedDescription )")
//        }
//    }
    
//    func callingAPI(pin: Pins) {
//
//        sharedFunc.callingAPI(lat: pin.latitude , long: pin.longitude , selfClass: self) {
//           // self.collectionViewer.reloadData()
//            let galleryData = CommonFunc.shared.galleryModel
//            print("GaleryCount = \(galleryData.count)")
//            for gallery in galleryData {
//                self.saveImagesinCore(galleryData: gallery)
//            }
//            //self.setupFetchedResultControllerWith(pin)
//        }
//    }
    
//    func saveImagesinCore(galleryData: GalleryModel) {
//        let urlString = galleryData.url_m ?? "URL not found"
//        print("url = \(urlString)")
//        guard let url = URL(string: urlString) else {return}
//
//        APIService.shared.getSingleImage(url: url) { (data) in
//            switch data {
//            case .Success(let data):
//
//                let photo = Photo(context: self.sharedFunc.dataController.viewContext)
//                photo.image = data
//                photo.imageUrl = galleryData.url_m
//                photo.title = galleryData.title
//                photo.pin = self.pin
//
//                self.sharedFunc.saved()
//
//
//
//            case .Error(let error):
//                print("Error = \(error)")
//            }
//        }
//    }

//    func updateFlowLayout(_ withSize: CGSize) {
//
//        let landscape = withSize.width > withSize.height
//        print("landscape = \(landscape)")
//        let space: CGFloat = landscape ? 5 : 3
//        let items: CGFloat = landscape ? 2 : 3
//
//        let dimension = (withSize.width - ((items + 1) * space)) / items
//
//        flowLayout?.minimumInteritemSpacing = space
//        flowLayout?.minimumLineSpacing = space
//        flowLayout?.itemSize = CGSize(width: dimension, height: dimension)
//        flowLayout?.sectionInset = UIEdgeInsets(top: space, left: space, bottom: space, right: space)
//    }
    
//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        updateFlowLayout(size)
//    }
//    
    
    @IBAction func newCollection(_ sender: Any) {
        
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
//extension PhotoAlbumViewController: UICollectionViewDataSource, UICollectionViewDelegate {
//
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        print("sections = \(String(describing: fetchResultsController.sections?.count))")
//        return fetchResultsController.sections?.count ?? 0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if let sectionInfo = self.fetchResultsController.sections?[section] {
//            print("Count = \(sectionInfo.numberOfObjects)")
//            return sectionInfo.numberOfObjects
//        }
//        return 0
//
//
//
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoViewerCollectionViewCell", for: indexPath) as! PhotoViewerCollectionViewCell
//
//       let photo = fetchResultsController.object(at: indexPath)
//        cell.coreConfig(photo: photo, pin: pin)
//
//        return cell
//    }
//
//
//
//}
//
//extension PhotoAlbumViewController: NSFetchedResultsControllerDelegate {
//
//    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        insertedIndexPaths = [IndexPath]()
//        deletedIndexPaths = [IndexPath]()
//        updatedIndexPaths = [IndexPath]()
//    }
//
////    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
////
////
////        insertedIndexPaths = [IndexPath]()
////        deletedIndexPaths = [IndexPath]()
////        updatedIndexPaths = [IndexPath]()
////    }
//
//    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//
//        collectionViewer.performBatchUpdates({() -> Void in
//
//            for indexPath in self.insertedIndexPaths {
//                self.collectionViewer.insertItems(at: [indexPath])
//            }
//
//            for indexPath in self.deletedIndexPaths {
//                self.collectionViewer.deleteItems(at: [indexPath])
//            }
//
//            for indexPath in self.updatedIndexPaths {
//                self.collectionViewer.reloadItems(at: [indexPath])
//            }
//
//        }, completion: nil)
////        collectionViewer.performBatchUpdates({
////
////            let _ = self.insertedIndexPaths.map{ self.collectionViewer.insertItems(at: [$0])}
////            let _ = self.deletedIndexPaths.map{ self.collectionViewer.insertItems(at: [$0])}
////             let _ = self.updatedIndexPaths.map{ self.collectionViewer.insertItems(at: [$0])}
////
////        }, completion: nil)
//    }
//
//
////    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
////        let indexSet = IndexSet(integer: sectionIndex)
////
////        switch type {
////        case .insert: collectionViewer.insertSections(indexSet)
////        case .delete: collectionViewer.deleteSections(indexSet)
////        case .update: fatalError("Not possible")
////        default:
////            break
////        }
////    }
//
//
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
//
//        switch (type) {
//        case .insert:
//            insertedIndexPaths.append(newIndexPath!)
//            print("IndexPathnew = \(insertedIndexPaths)")
//            break
//        case .delete:
//            deletedIndexPaths.append(indexPath!)
//            break
//        case .update:
//            updatedIndexPaths.append(indexPath!)
//            break
//        case .move:
//            print("Move an item. We don't expect to see this in this app.")
//            break
//        }
////        switch type {
////        case .insert:
////            collectionViewer.insertItems(at: [indexPath!])
////        case .delete:
////            collectionViewer.deleteItems(at: [indexPath!])
////        case .update:
////            collectionViewer.reloadItems(at: [indexPath!])
////        case .move:
////          //  collectionViewer.moveRow(at: indexPath!, to: newIndexPath!)
////            collectionViewer.moveItem(at: indexPath!, to: newIndexPath!)
////        }
//
//    }
//
//}
