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
    
    
    
    func coreConfig(photo: Photo, pin: Pins) {
        self.ImageViewer.image = UIImage(named: "Image")
        // guard let imaged = photo.image else {print("coreImage😩");return}
        if let imaged = photo.image {
            print("dataInCOre")
            self.ImageViewer.image = UIImage(data: imaged)
        } else {
            print("NoCore")
            
            if let imageURL = photo.imageUrl {
                guard let url = URL(string: imageURL) else {return}
                
                APIService.shared.getSingleImage(url: url) { (data) in
                    switch data {
                    case .Success(let data):
                        self.ImageViewer.image = UIImage(data: data)
                        
                        let photo = Photo(context: CommonFunc.shared.dataController.viewContext)
                        photo.image = data
                        photo.pin = pin
                        
                        CommonFunc.shared.saved()
//                        self.sharedFunc.saved()
//                        let photo = Photo(context: CommonFunc.shared.dataController.viewContext)
//                        photo.image = data
                        
                        
                    case .Error(let error):
                        print("Error = \(error)")
                    }
                }
            } 
        }
       
        
    }
    
}
