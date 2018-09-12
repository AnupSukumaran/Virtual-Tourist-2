//
//  CommonFunctions+Extension.swift
//  Virtual Tourist
//
//  Created by Sukumar Anup Sukumaran on 11/09/18.
//  Copyright © 2018 TechTonic. All rights reserved.
//

import Foundation

extension CommonFunc {
    
    
    
    func callingAPI(lat: Double, long: Double, selfClass: AnyObject, completion: @escaping() -> ()) {
        guard let selfVC = selfClass as? PhotoAlbumViewController else {return}
        APIService.shared.getAllImages(lat: lat, long: long) { (response) in
            switch response {
            case .Success(let data):
            self.galleryModel = data.galleryModel
            completion()
                
            case .Error(let error):
                AlertView.showAlert(message: error, UIVIews: selfVC)
            
            }
        }
    }
    
}
