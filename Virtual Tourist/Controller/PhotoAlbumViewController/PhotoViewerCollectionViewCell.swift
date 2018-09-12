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
        
        let urlString = galleryData.url_m ?? "URL not found"
        print("url = \(urlString)")
        guard let url = URL(string: urlString) else {return}
        
        APIService.shared.getSingleImage(url: url) { (data) in
            switch data {
            case .Success(let data):
                self.ImageViewer.image = UIImage(data: data)
            case .Error(let error):
                print("Error = \(error)")
            }
        }
    }
    
}
