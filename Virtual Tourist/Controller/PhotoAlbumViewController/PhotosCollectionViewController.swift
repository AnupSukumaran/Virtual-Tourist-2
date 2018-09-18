//
//  PhotosCollectionViewController.swift
//  Virtual Tourist
//
//  Created by Sukumar Anup Sukumaran on 16/09/18.
//  Copyright © 2018 TechTonic. All rights reserved.
//

import UIKit
import CoreData



private let reuseIdentifier = "PhotoViewerCollectionViewCell"

class PhotosCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var dataController: DataController = CommonFunc.shared.dataController
    let sharedFunc = CommonFunc.shared
    var pin:Pins!
    var fetchResultsController: NSFetchedResultsController<Photo>!
    
    var selectedIndexes = [IndexPath]()
    var insertedIndexPaths: [IndexPath]!
    var deletedIndexPaths: [IndexPath]!
    var updatedIndexPaths: [IndexPath]!
    
     var blockOperations: [BlockOperation] = []
    
    let sectionInsets = UIEdgeInsets(top: 3.0, left: 3.0, bottom: 3.0, right: 3.0)
    
    var photoAlbum =  PhotoAlbumViewController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Pin = \(pin.latitude)")
        self.postingNotificationForDeviceOrientations()
        
        photoAlbum.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //  setupFetchResultsControllerMethod()
        setupFetchedResultControllerWith(pin)
        if let photos = pin.photos, photos.count == 0 {
            callingAPI()
            pirntaction()
        } else {
            print("PicCount = \(pin.photos!.count)")
        }
    }
    func pirntaction() {
        print("Hello")
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
      //  fetchResultsController = nil
    }
    
    private func setupFetchedResultControllerWith(_ pin: Pins) {
        print("setuping --FetchedResultControllerWith")
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        let predicate = NSPredicate(format: "pin == %@", pin)
        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "imageUrl", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Create the FetchedResultsController
        fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CommonFunc.shared.dataController.viewContext, sectionNameKeyPath: nil, cacheName: "\(pin.latitude)")
        fetchResultsController.delegate = self
        
        
        
        // Start the fetched results controller
        var error: NSError?
        do {
            print("fetching data")
            try fetchResultsController.performFetch()  //2
        } catch let error1 as NSError {
            print("Error while fetching")
            error = error1
        }
        
        if let error = error {
            print("CoreData 😒Error performing initial fetch: \(error)")
        }
        
        print("DoneFetchingFunc")
        
    }
    
    func callingAPI() {
        print("CallingAPI = \(pin.latitude)")
        
        CommonFunc.shared.callingAPI(lat: pin.latitude , long: pin.longitude, selfVC: self) {
            print("pin latiti = \(self.pin.latitude)")
            let galleryData = CommonFunc.shared.galleryModel
            print("GaleryCount = \(galleryData.count)")
            for gallery in galleryData {
                self.saveImagesinCore(galleryData: gallery)
            }
            //self.setupFetchedResultControllerWith(pin)
        }
        
    }
    
    func saveImagesinCore(galleryData: GalleryModel) {
        let urlString = galleryData.url_m ?? "URL not found"
        print("url = \(urlString)")
        guard let url = URL(string: urlString) else {return}
        
        APIService.shared.getSingleImage(url: url) { (data) in
            switch data {
            case .Success(let data):
                
                let photo = Photo(context: self.sharedFunc.dataController.viewContext)
                photo.image = data
                photo.imageUrl = galleryData.url_m
                photo.title = galleryData.title
                photo.pin = self.pin
                
                self.sharedFunc.saved()
                
                
                
            case .Error(let error):
                print("Error = \(error)")
            }
        }
    }
    
    func callNewCollectionAction() {
        let _ = fetchResultsController.fetchedObjects!.map{ sharedFunc.dataController.viewContext.delete($0)}
        sharedFunc.saved()
        callingAPI()
    }
    
    func postingNotificationForDeviceOrientations() {
        NotificationCenter.default.addObserver(self, selector: #selector(orientationDidChange), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func orientationDidChange(notification: NSNotification) {
        collectionView!.collectionViewLayout.invalidateLayout()
        print("check")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

  
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
         return fetchResultsController.sections?.count ?? 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        if let sectionInfo = self.fetchResultsController.sections?[section] {
            print("Count = \(sectionInfo.numberOfObjects)")
            return sectionInfo.numberOfObjects
        }
        return 0

    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoViewerCollectionViewCell", for: indexPath) as! PhotoViewerCollectionViewCell
        
        let photo = fetchResultsController.object(at: indexPath)
        cell.coreConfig(photo: photo, pin: pin)
        
        return cell
    }
    
   override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        if cell?.isSelected == true {
         cell?.backgroundColor = UIColor.gray
        } else {
            cell?.backgroundColor = UIColor.clear
        }
    }

    
}

extension PhotosCollectionViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndexPaths = [IndexPath]()
        print("insertedIndexPaths = \(insertedIndexPaths)")
        deletedIndexPaths = [IndexPath]()
        updatedIndexPaths = [IndexPath]()
    }
    
    //    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    //
    //
    //        insertedIndexPaths = [IndexPath]()
    //        deletedIndexPaths = [IndexPath]()
    //        updatedIndexPaths = [IndexPath]()
    //    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        collectionView!.performBatchUpdates({() -> Void in
            print("countIndx = \(self.insertedIndexPaths.count) ")
            for indexPath in self.insertedIndexPaths {
                self.collectionView!.insertItems(at: [indexPath])
            }
            
            for indexPath in self.deletedIndexPaths {
                self.collectionView!.deleteItems(at: [indexPath])
            }
            
            for indexPath in self.updatedIndexPaths {
                self.collectionView!.reloadItems(at: [indexPath])
            }
            
        }, completion: nil)
        //        collectionViewer.performBatchUpdates({
        //
        //            let _ = self.insertedIndexPaths.map{ self.collectionViewer.insertItems(at: [$0])}
        //            let _ = self.deletedIndexPaths.map{ self.collectionViewer.insertItems(at: [$0])}
        //             let _ = self.updatedIndexPaths.map{ self.collectionViewer.insertItems(at: [$0])}
        //
        //        }, completion: nil)
    }
    
    
    //    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
    //        let indexSet = IndexSet(integer: sectionIndex)
    //
    //        switch type {
    //        case .insert: collectionViewer.insertSections(indexSet)
    //        case .delete: collectionViewer.deleteSections(indexSet)
    //        case .update: fatalError("Not possible")
    //        default:
    //            break
    //        }
    //    }
    
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch (type) {
        case .insert:
            print("didChangenewIndexPath = \(String(describing: newIndexPath))")
            insertedIndexPaths.append(newIndexPath!)
//            print("IndexPathnew = \(insertedIndexPaths)")
//            break
            
           //  collectionView?.reloadData()
//            if (collectionView?.numberOfSections)! > 0 {
//
//                if collectionView?.numberOfItems( inSection: newIndexPath!.section ) == 0 {
////                    self.shouldReloadCollectionView = true
//                } else {
//                    blockOperations.append(
//                        BlockOperation(block: { [weak self] in
//                            if let this = self {
//                                DispatchQueue.main.async {
//                                    this.collectionView!.insertItems(at: [newIndexPath!])
//                                }
//                            }
//                        })
//                    )
//                }
//            }
            
        case .delete:
            deletedIndexPaths.append(indexPath!)
//            break
          //  collectionView?.deleteItems(at: [indexPath!])
        case .update:
            updatedIndexPaths.append(indexPath!)
//            break
            //collectionView?.reloadItems(at: [indexPath!])
            
        case .move:
            print("Move an item. We don't expect to see this in this app.")
            break
        }
        //        switch type {
        //        case .insert:
        //            collectionViewer.insertItems(at: [indexPath!])
        //        case .delete:
        //            collectionViewer.deleteItems(at: [indexPath!])
        //        case .update:
        //            collectionViewer.reloadItems(at: [indexPath!])
        //        case .move:
        //          //  collectionViewer.moveRow(at: indexPath!, to: newIndexPath!)
        //            collectionViewer.moveItem(at: indexPath!, to: newIndexPath!)
        //        }
        
    }
    
}

extension PhotosCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let dimension = (view.frame.size.width - (4 * sectionInsets.left)) / 3.0
        
        return CGSize(width: dimension, height: dimension)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return sectionInsets.left
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
}

extension PhotosCollectionViewController: NewCollectionDelegate {
    func clearForNewCollection() {
        print("delegateWorks")
        callNewCollectionAction()
    }
    
    
}


