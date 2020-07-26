//
//  TravelLocationsMapViewController.swift
//  Virtual Tourist
//
//  Created by Sukumar Anup Sukumaran on 09/09/18.
//  Copyright © 2018 TechTonic. All rights reserved.
//

import UIKit
import MapKit


class TravelLocationsMapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var EditButton: UIBarButtonItem!
    @IBOutlet weak var EditView: UIView!
    @IBOutlet var longPressGestures: UILongPressGestureRecognizer!
  
    var viewModel: TravelLocationsMapViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        EditButton.title = "Edit"
        viewModel.callingInitialMapState(mapView: mapView)
      //  viewModel.fetchRequest(mapView: mapView)
//        viewModel.dataController.fetch(sortOrderKey: "latitude", ascending: false, forType: [Pins]()) { (data) in
//
//           // guard let pins = data as? [Pins] else {return}
//            viewModel.pins = data
//            viewModel.createAnnotations(pins: viewModel.pins, mapView: mapView)
//        }
        
        if let pins = viewModel.dataController.fetchDataWith(sortOrderKey: "latitude", ascending: false, entityName: Pins.enitiyName) as? [Pins] {
            viewModel.pins = pins
            viewModel.createAnnotations(pins: viewModel.pins, mapView: mapView)
        }

    }
    
    func doneEditBtn() {
        EditButton.title = "Done"
        UIView.animate(withDuration: 0.2) {
            self.mapView.bounds.origin.y = self.EditView.frame.height
            self.longPressGestures.isEnabled = false
        }
    }
    
    func editBtn() {
        EditButton.title = "Edit"
        UIView.animate(withDuration: 0.2) {
            self.mapView.bounds.origin.y = 0.0
            self.longPressGestures.isEnabled = true
        }
    }

    @IBAction func AddPinsAction(_ sender: UILongPressGestureRecognizer) {
        viewModel.callingPinToDrop(sender, mapView: mapView)
    }
        
    @IBAction func EditingAction(_ sender: UIBarButtonItem) {
        viewModel.EditingAction { (state) in
            if state {
                doneEditBtn()
            } else {
                editBtn()
            }
        }
    
    }
    
    
}




extension NSObject {
    
    static var enitiyName: String {
        return String(describing: self)
    }
}
