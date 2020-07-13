//
//  PhotosCollectionViewModel.swift
//  Virtual Tourist
//
//  Created by Sukumar Anup Sukumaran on 12/07/20.
//  Copyright © 2020 TechTonic. All rights reserved.
//

import UIKit
import CoreData
import SASLogixsPack


class PhotosCollectionViewModel: NSObject {

    var dataController: DataController!
    
    var fetchResultsController: NSFetchedResultsController<Photo>!
    
    var pin:Pins!
    
    let sectionInsets = UIEdgeInsets(top: 3.0, left: 3.0, bottom: 3.0, right: 3.0)
    
    weak var delegate: SelectionCollectionDelegate?
    
    var selectedPhotos = [Photo]()
    var viewSizeForCollCell: CGFloat = 0
    
    var selectedIndexes = [IndexPath]()
    var insertedIndexPaths: [IndexPath]!
    var deletedIndexPaths: [IndexPath]!
    var updatedIndexPaths: [IndexPath]!
    
     var galleryModel = [GalleryModel]()
    
    var controllerDidChangeContent: (() -> ())?
    var refreshCollView: (() -> ())?
    
    override init() {}
    
    init(dataController: DataController, pin:Pins?) {
        self.dataController = dataController
        self.pin = pin
        
        super.init()
        
        setupFetchedResultControllerWith(self.pin)
        
        
        if let photos = pin!.photos, photos.count == 0 {
            callingAPI()
        }
        //self.mapView = mapView
    }
    
    
    func setupFetchedResultControllerWith(_ pin: Pins) {
        print("setuping --FetchedResultControllerWith")
        
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        let predicate = NSPredicate(format: "pin == %@", pin)
        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "imageUrl", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Create the FetchedResultsController
        fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: "\(pin.latitude)")
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
    
    
    func callNewCollectionAction() {
        let _ = fetchResultsController.fetchedObjects!.map{ dataController.viewContext.delete($0)}
        dataController.saved()
        //sharedFunc.saved()
        callingAPI()
    }
    
    
    func deleteOnlySelectedCell() {
        print("deleteSelctedCells")
        
        for items in selectedPhotos {
            dataController.deleted(items)
            //dataController.viewContext.delete(items)
            dataController.saved()
            //sharedFunc.saved()
        }
        selectedPhotos.removeAll()
        
        delegate?.delectedSelectedCell(hasSelection: false)
    }
    
    func callingAPI() {
        print("CallingAPI = \(pin.latitude)")
        
        callingAPIToGetImages(lat: pin.latitude, long: pin.longitude) {galleryArr in
            self.galleryModel = galleryArr
            self.refreshCollView?()
            for gallery in self.galleryModel {
                self.saveImagesinCore(galleryData: gallery)
            }
        }
        
    }
    
    func saveImagesinCore(galleryData: GalleryModel) {
            
        
            let photo = Photo(context: dataController.viewContext)
            photo.imageUrl = galleryData.url_m
            photo.title = galleryData.title
            photo.pin = self.pin
            dataController.saved()
          
        }
    
    func callingAPIToGetImages(lat: Double, long: Double, completion: @escaping(_ galleryModel: [GalleryModel]) -> ()) {
        
        APIService.shared.getAllImages(lat: lat, long: long) { (response) in
            switch response {
            case .Success(let data):
            //self.galleryModel = data.galleryModel
            completion(data.galleryModel)
                
            case .Error(let error):
                UIAlertController().showSuperAlertView(title: "Message", message: "Error = \(error)", actionTitles: ["OK"], actions: nil)
            
            }
        }
    }
    
}


extension PhotosCollectionViewModel: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
         return fetchResultsController.sections?.count ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            if let sectionInfo = self.fetchResultsController.sections?[section] {
              print("Count = \(sectionInfo.numberOfObjects)")
              return sectionInfo.numberOfObjects
            }
            return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoViewerCollectionViewCell", for: indexPath) as! PhotoViewerCollectionViewCell
        
        let photo = fetchResultsController.object(at: indexPath)
        cell.coreConfig(photo: photo, pin: pin, dataController: dataController)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            delegate?.delectedSelectedCell(hasSelection: true)

            let selectedPhoto = fetchResultsController.object(at: indexPath)

            selectedPhotos.append(selectedPhoto)

            print("selectedCount = \(selectedPhotos.count)")
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        if collectionView.indexPathsForSelectedItems?.count == 0 {
            delegate?.delectedSelectedCell(hasSelection: false)
        }
        
         let deselectedPhoto = fetchResultsController.object(at: indexPath)
        
        guard let deselectedPhotoIndex = selectedPhotos.firstIndex(of: deselectedPhoto) else { return }
        
        selectedPhotos.remove(at: deselectedPhotoIndex)
          print("selectedCount = \(selectedPhotos.count)")
        
    }
    
    
    
    
}

extension PhotosCollectionViewModel: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        insertedIndexPaths = [IndexPath]()
        deletedIndexPaths = [IndexPath]()
        updatedIndexPaths = [IndexPath]()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        controllerDidChangeContent?()
        
//        collectionView!.performBatchUpdates({ () -> Void in
//
//            let _ = self.insertedIndexPaths.map{ self.collectionView!.insertItems(at: [$0])}
//            let _ = self.deletedIndexPaths.map{ self.collectionView!.deleteItems(at: [$0])}
//            let _ = self.updatedIndexPaths.map{ self.collectionView!.reloadItems(at: [$0])}
//
//        }, completion: nil)
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch (type) {
        case .insert:
            
            print("didChangenewIndexPath = \(String(describing: newIndexPath))")
            insertedIndexPaths.append(newIndexPath!)

        case .delete:

           deletedIndexPaths.append(indexPath!)
           
        case .update:
            
            updatedIndexPaths.append(indexPath!)
    
        case .move:
            print("Move an item. We don't expect to see this in this app.")
            
            break
        @unknown default:
            
            fatalError("fatalError")
        }
        
    }
}

extension PhotosCollectionViewModel: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
       // let dimension = (view.frame.size.width - (4 * sectionInsets.left)) / 3.0
        
        let dimension = (viewSizeForCollCell - (4 * sectionInsets.left)) / 3.0
        
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

extension PhotosCollectionViewModel: NewCollectionDelegate {
    
    func deleteSelectedCell() {
        print("deleteSelectedCellDelegateWorks")
        deleteOnlySelectedCell()
    }
    
    func clearForNewCollection() {
        print("delegateWorks")
        callNewCollectionAction()
    }
    
    
}
