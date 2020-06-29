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
    var dataController: DataController!

    override func viewDidLoad() {
        super.viewDidLoad()
        EditButton.title = "Edit"
        viewModel = TravelLocationsMapViewModel(dataController: dataController, mapView: mapView)
        viewModel.callingInitialMapState()
        viewModel.fetchRequest()

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
        viewModel.callingPinToDrop(sender)
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



