//
//  GalleryModel.swift
//  Virtual Tourist
//
//  Created by Sukumar Anup Sukumaran on 11/09/18.
//  Copyright © 2018 TechTonic. All rights reserved.
//

import Foundation


class GalleryModel {
    
    let url_m: String?
    let title: String?
    
    init?(json: JSON) {
        let url_m = json[Constants.url_m] as? String
        let title = json[Constants.title] as? String
        
        self.url_m = url_m
        self.title = title
    }
    
}
