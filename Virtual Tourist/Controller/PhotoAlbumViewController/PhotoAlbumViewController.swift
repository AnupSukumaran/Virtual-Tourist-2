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
    
    
    var viewModel: PhotoAlbumViewModel! {
        didSet {
            photoAlbumViewModelComps()
        }
    }
    
 //   var locModel: LocModel?
    
//    var lat: Double?
//    var long: Double?
//    var zlat: Double?
//    var zlong: Double?
    
   // var dataController: DataController!// = CommonFunc.shared.dataController
    //let sharedFunc = CommonFunc.shared
  //  var pin:Pins?
   // weak var delegate: NewCollectionDelegate?
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        
        mapView.isZoomEnabled = false
        mapView.isScrollEnabled = false
        mapView.delegate = viewModel

        if let pins = viewModel.pin {
            viewModel.showOnTheMap(pins, mapView: mapView)
        }
        
//        if let pin = pin {
//            viewModel.showOnTheMap(pin, mapView: mapView)
//        } else {print(" Pin not found 😩");return}
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
    }
    
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
      
    }
    
    func photoAlbumViewModelComps() {
        
        viewModel.changeButtonNameComp = { [weak self] (hasSelected) in
            guard let vc = self else {return}
            if hasSelected {
              vc.viewModel.hasSelectedCell = hasSelected
              vc.newCollectionButton.setTitle("Remove Selected Pictures", for: .normal)
            } else {
              vc.viewModel.hasSelectedCell = hasSelected
              vc.newCollectionButton.setTitle("New Collection", for: .normal)
            }
           
        }
    }
    
    
   
    func changeButtonName(hasSelection: Bool) {
        
        if hasSelection {
            
            self.newCollectionButton.setTitle("Remove Selected Pictures", for: .normal)
        } else {
            
            self.newCollectionButton.setTitle("New Collection", for: .normal)
        }
        
    }

    
    @IBAction func newCollection(_ sender: Any) {
        print("callingDelegate")
        
        if viewModel.hasSelectedCell {
            
            viewModel.delegate?.deleteSelectedCell()
           // delegate?.deleteSelectedCell()
        } else {
            
            viewModel.delegate?.clearForNewCollection()
            //delegate?.clearForNewCollection()
        }
        
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
 
        let vc = segue.destination as! PhotosCollectionViewController
        vc.viewModel = PhotosCollectionViewModel(dataController: viewModel.dataController, pin:viewModel.pin)
//                vc.dataController = dataController
//                vc.pin = pin
        viewModel.delegate = vc.viewModel
        vc.viewModel.delegate = viewModel
        //viewModel.delegate = vc.viewModel
//                vc.photoAlbum = self
//                vc.delegate = self
        
    }
    

}

//extension PhotoAlbumViewController: MKMapViewDelegate {
//
//
//func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//
//    let reuseId = "pin"
//
//    var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
//
//    if pinView == nil {
//        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
//        pinView!.canShowCallout = false
//        pinView!.pinTintColor = .red
//        pinView!.animatesDrop = true
//    } else {
//        pinView!.annotation = annotation
//    }
//
//    return pinView
//   }
//}
//
//extension PhotoAlbumViewController: SelectionCollectionDelegate {
//
//    func delectedSelectedCell(hasSelection: Bool) {
//        print("Has Selection = \(hasSelection)")
//        changeButtonName(hasSelection: hasSelection)
//    }
//
//
//}

