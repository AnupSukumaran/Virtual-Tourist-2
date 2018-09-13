//
//  PhotoViewerCollectionViewCell.swift
//  Virtual Tourist
//
//  Created by Sukumar Anup Sukumaran on 10/09/18.
//  Copyright © 2018 TechTonic. All rights reserved.
//

import UIKit

class PhotoViewerCollectionViewCell: UICollectionViewCell {
    
   // var dataController: DataController!
    @IBOutlet weak var ImageViewer: UIImageView!
    
    func config(galleryData: GalleryModel) {
        
        let urlString = galleryData.url_m ?? "URL not found"
        print("url = \(urlString)")
        guard let url = URL(string: urlString) else {return}
        
        APIService.shared.getSingleImage(url: url) { (data) in
            switch data {
            case .Success(let data):
                self.ImageViewer.image = UIImage(data: data)
                
                let photo = Photo(context: CommonFunc.shared.dataController.viewContext)
                photo.image = data
                CommonFunc.shared.saved()
                
            case .Error(let error):
                print("Error = \(error)")
            }
        }
    }
    
    func coreConfig(photo: Photo) {
        guard let imaged = photo.image else {print("coreImage😩");return}
        self.ImageViewer.image = UIImage(data: imaged)
    }
    
}
