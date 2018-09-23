//
//  PhotoViewerCollectionViewCell.swift
//  Virtual Tourist
//
//  Created by Sukumar Anup Sukumaran on 10/09/18.
//  Copyright © 2018 TechTonic. All rights reserved.
//

import UIKit
import CoreData

class PhotoViewerCollectionViewCell: UICollectionViewCell {
    
   // var dataController: DataController!
    @IBOutlet weak var ImageViewer: UIImageView!
   //@IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var selectionView: UIView!
    
    override var isSelected: Bool {
        didSet{
            print("seelcted = \(isSelected)")
            selectionView.isHidden = !isSelected
        }
    }
    
    
    func coreConfig(photo: Photo, pin: Pins) {
        self.activityIndicator.startAnimating()
        self.ImageViewer.image = UIImage(named: "Image")
        if let imaged = photo.image {
            self.activityIndicator.stopAnimating()
            print("dataInCore")
            self.ImageViewer.image = UIImage(data: imaged)
        } else {
            print("NoCore")
            let backgroundContext: NSManagedObjectContext! = CommonFunc.shared.dataController.backgroundContext
            if let imageURL = photo.imageUrl {
                guard let url = URL(string: imageURL) else {return}
                
                APIService.shared.getSingleImage(url: url) { (data) in
                    switch data {
                    case .Success(let data):
                         self.activityIndicator.stopAnimating()
                        self.ImageViewer.image = UIImage(data: data)
                        let photoID = photo.objectID
                        
                        backgroundContext.perform {
                            let backgrounfPin = backgroundContext.object(with: photoID) as! Photo
                            backgrounfPin.image = data

                            do {
                                try backgroundContext.save()
                            } catch let error{
                                print("Error 😩")
                                fatalError(error.localizedDescription)
                            }
                        }
                        

                        
                    case .Error(let error):
                         self.activityIndicator.stopAnimating()
                        print("Error = \(error)")
                    }
                }
            } 
        }
       
        
    }
    
}
