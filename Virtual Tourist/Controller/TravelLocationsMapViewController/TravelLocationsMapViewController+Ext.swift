//
//  TravelLocationsMapViewController+Ext.swift
//  Virtual Tourist
//
//  Created by Sukumar Anup Sukumaran on 28/06/20.
//  Copyright © 2020 TechTonic. All rights reserved.
//

import Foundation
import MapKit

struct LocModel {
    var lat: CLLocationDegrees
    var lon: CLLocationDegrees
    var zLat: CLLocationDegrees
    var zLong: CLLocationDegrees
}


extension TravelLocationsMapViewController: MKMapViewDelegate {
    
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        viewModel.saveLocationDataAsMapMoves(mapView)

    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    
        return viewModel.settingUpPinView(mapV: mapView, annotation: annotation)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        guard let values = viewModel.getAnnotaionsOrLocModel(view: view, mapView: mapView) else {return}
        let annotation = values.annotation
        let locModel = values.locModel

        if viewModel.isEdititng {
            viewModel.loadPinsFromCoreAndDeleteThemAndSaveChanges(mv: mapView, annotation: annotation)
        } else {
            print("non-editing mode")
            performSegue(withIdentifier: "showVC", sender: locModel)
        }
       
        viewModel.removePins(mv: mapView)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let backItem = UIBarButtonItem()
        backItem.title = "OK"
        navigationItem.backBarButtonItem = backItem
        
        if let dict = sender as? LocModel {
        print("dict = \(dict)")
            
            if segue.identifier == "showVC" {
                let vc = segue.destination as! PhotoAlbumViewController
              //  vc.locModel = dict
                
//                let ss = viewModel.loadPin(latitude: dict.lat , longitude: dict.lon )
//                let ssss = ss?.latitude
                
                vc.viewModel = PhotoAlbumViewModel(dataController: viewModel.dataController, pins: viewModel.loadPin(latitude: dict.lat , longitude: dict.lon ))
                
              //  vc.dataController = viewModel.dataController
//                if let pin = viewModel.loadPin(latitude: dict.lat , longitude: dict.lon ) {
//                    vc.pin = pin
//                }
            }
        } else {print("Failed Casting")}

    }
    
}
