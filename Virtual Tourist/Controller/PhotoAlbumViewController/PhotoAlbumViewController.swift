//
//  PhotoAlbumViewController.swift
//  Virtual Tourist
//
//  Created by Sukumar Anup Sukumaran on 10/09/18.
//  Copyright © 2018 TechTonic. All rights reserved.
//

import UIKit

class PhotoAlbumViewController: UIViewController {
    
    
    var lat: Double?
    var long: Double?
    var zlat: Double?
    var zlong: Double?
    
    let sharedFunc = CommonFunc.shared
    
    @IBOutlet weak var collectionViewer: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateFlowLayout(view.frame.size)
        print("lat = \(lat!), long = \(long!), zlat = \(zlat!),zlong = \(zlong!) ")
        sharedFunc.callingAPI(lat: lat ?? 0.0, long: long ?? 0.0, selfClass: self) {
            self.collectionViewer.reloadData()
        }
    }

    func updateFlowLayout(_ withSize: CGSize) {
        
        let landscape = withSize.width > withSize.height
        print("landscape = \(landscape)")
        let space: CGFloat = landscape ? 5 : 3
        let items: CGFloat = landscape ? 2 : 3
        
        let dimension = (withSize.width - ((items + 1) * space)) / items
        
        flowLayout?.minimumInteritemSpacing = space
        flowLayout?.minimumLineSpacing = space
        flowLayout?.itemSize = CGSize(width: dimension, height: dimension)
        flowLayout?.sectionInset = UIEdgeInsets(top: space, left: space, bottom: space, right: space)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        updateFlowLayout(size)
    }
    

}

extension PhotoAlbumViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       print("Count = \(sharedFunc.galleryModel.count)")
        return sharedFunc.galleryModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoViewerCollectionViewCell", for: indexPath) as! PhotoViewerCollectionViewCell
        
        cell.config(galleryData: sharedFunc.galleryModel[indexPath.row])
        
        return cell
    }
    
    
}
