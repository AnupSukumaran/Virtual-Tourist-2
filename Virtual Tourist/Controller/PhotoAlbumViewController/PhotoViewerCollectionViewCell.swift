//
//  PhotoViewerCollectionViewCell.swift
//  Virtual Tourist
//
//  Created by Sukumar Anup Sukumaran on 10/09/18.
//  Copyright © 2018 TechTonic. All rights reserved.
//

import UIKit

class PhotoViewerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var ImageViewer: UIImageView!
    
    func config(galleryData: GalleryModel) {
        
        let url = galleryData.url_m ?? "URL not found"
        print("url = \(url)")
        
    }
    
}
