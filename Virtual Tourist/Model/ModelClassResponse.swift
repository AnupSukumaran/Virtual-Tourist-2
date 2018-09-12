//
//  ModelClassResponse.swift
//  Virtual Tourist
//
//  Created by Sukumar Anup Sukumaran on 11/09/18.
//  Copyright © 2018 TechTonic. All rights reserved.
//

import Foundation


class ModelClassResponse {
    
    var galleryModel = [GalleryModel]()
    
    init(json: JSON) {
        
        if let photos = json[Constants.photos] as? JSON {
            if let photo = photos[Constants.photo] as? [JSON] {
                let galleryArray = photo.map { GalleryModel(json: $0)}.compactMap{$0}
                self.galleryModel = galleryArray
            }
        }
        
    }
    
}
