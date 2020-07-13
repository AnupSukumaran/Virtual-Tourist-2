//
//  PhotosCollectionViewController.swift
//  Virtual Tourist
//
//  Created by Sukumar Anup Sukumaran on 16/09/18.
//  Copyright © 2018 TechTonic. All rights reserved.
//

import UIKit
import CoreData

protocol SelectionCollectionDelegate: class {
    func delectedSelectedCell(hasSelection: Bool)
}

private let reuseIdentifier = "PhotoViewerCollectionViewCell"

class PhotosCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var viewModel: PhotosCollectionViewModel! {
        didSet {
            viewModelCompBlksSetter()
        }
    }
    
//    weak var delegate: SelectionCollectionDelegate?
//    var dataController: DataController!// = CommonFunc.shared.dataController
//    let sharedFunc = CommonFunc.shared
//    var pin:Pins!
//    var fetchResultsController: NSFetchedResultsController<Photo>!
//
//    var selectedIndexes = [IndexPath]()
//    var insertedIndexPaths: [IndexPath]!
//    var deletedIndexPaths: [IndexPath]!
//    var updatedIndexPaths: [IndexPath]!
//
    //var blockOperations: [BlockOperation] = []
    
//    let sectionInsets = UIEdgeInsets(top: 3.0, left: 3.0, bottom: 3.0, right: 3.0)
//     var selectedPhotos = [Photo]()
    
//    weak var photoAlbum: PhotoAlbumViewController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        viewModel.viewSizeForCollCell = view.frame.size.width
        collectionView.delegate = viewModel
        collectionView.dataSource = viewModel
        
        self.postingNotificationForDeviceOrientations()
        
//        photoAlbum!.delegate = self
        
      //  photoAlbum!.delegate = viewModel
        
        
        collectionView?.allowsMultipleSelection = true
       // viewModelCompBlksSetter()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //  setupFetchResultsControllerMethod()
//        setupFetchedResultControllerWith(pin)viewModel.
//        if let photos = pin.photos, photos.count == 0 {
//            viewModel.callingAPI()
//
//        }
    }
  
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
      //  fetchResultsController = nil
    }
    
    func viewModelCompBlksSetter() {
        
        viewModel.controllerDidChangeContent = { [weak self] in
            
            
            guard let vc = self else {return}
            
            vc.collectionView!.performBatchUpdates({ () -> Void in

                vc.viewModel.insertedIndexPaths.forEach{vc.collectionView!.insertItems(at: [$0])}
                vc.viewModel.deletedIndexPaths.forEach{vc.collectionView!.deleteItems(at: [$0])}
                vc.viewModel.updatedIndexPaths.forEach{vc.collectionView!.reloadItems(at: [$0])}

            }, completion: nil)
            
            
        }
        
        viewModel.refreshCollView = {[weak self] in
            guard let vc = self else {return}
            vc.collectionView.reloadData()
        }
    }
    
//    private func setupFetchedResultControllerWith(_ pin: Pins) {
//        print("setuping --FetchedResultControllerWith")
//        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
//        let predicate = NSPredicate(format: "pin == %@", pin)
//        fetchRequest.predicate = predicate
//        let sortDescriptor = NSSortDescriptor(key: "imageUrl", ascending: false)
//        fetchRequest.sortDescriptors = [sortDescriptor]
//
//        // Create the FetchedResultsController
//        fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: "\(pin.latitude)")
//        fetchResultsController.delegate = self
//
//
//
//        // Start the fetched results controller
//        var error: NSError?
//        do {
//            print("fetching data")
//            try fetchResultsController.performFetch()  //2
//        } catch let error1 as NSError {
//            print("Error while fetching")
//            error = error1
//        }
//
//        if let error = error {
//            print("CoreData 😒Error performing initial fetch: \(error)")
//        }
//
//        print("DoneFetchingFunc")
//
//    }
    
//    func callingAPI() {
//        print("CallingAPI = \(pin.latitude)")
//
//        CommonFunc.shared.callingAPI(lat: pin.latitude , long: pin.longitude, selfVC: self) {
//            print("pin latiti = \(self.pin.latitude)")
//            let galleryData = CommonFunc.shared.galleryModel
//            print("GaleryCount = \(galleryData.count)")
//            for gallery in galleryData {
//                self.saveImagesinCore(galleryData: gallery)
//            }
//            //self.setupFetchedResultControllerWith(pin)
//        }
//
//    }
    
//    func saveImagesinCore(galleryData: GalleryModel) {
//
//
//        let photo = Photo(context: dataController.viewContext)
//        photo.imageUrl = galleryData.url_m
//        photo.title = galleryData.title
//        photo.pin = self.pin
//        viewModel.dataController.saved()
//       // self.sharedFunc.saved()
//
////        APIService.shared.getSingleImage(url: url) { (data) in
////            switch data {
////            case .Success(let data):
////
////                let photo = Photo(context: self.sharedFunc.dataController.viewContext)
////                photo.image = data
////                photo.imageUrl = galleryData.url_m
////                photo.title = galleryData.title
////                photo.pin = self.pin
////
////                self.sharedFunc.saved()
////
////
////
////            case .Error(let error):
////                print("Error = \(error)")
////            }
////        }
//    }
    
//    func callNewCollectionAction() {
//        let _ = fetchResultsController.fetchedObjects!.map{ dataController.viewContext.delete($0)}
//        viewModel.dataController.saved()
//        //sharedFunc.saved()
//        callingAPI()
//    }
    
//    func deleteOnlySelectedCell() {
//        print("deleteSelctedCells")
//        for items in selectedPhotos {
//            viewModel.dataController.deleted(items)
//            //dataController.viewContext.delete(items)
//            viewModel.dataController.saved()
//            //sharedFunc.saved()
//        }
//        selectedPhotos.removeAll()
//        delegate?.delectedSelectedCell(hasSelection: false)
//    }
    
    func postingNotificationForDeviceOrientations() {
        NotificationCenter.default.addObserver(self, selector: #selector(orientationDidChange), name: UIDevice.orientationDidChangeNotification, object: nil)
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

  
//    override func numberOfSections(in collectionView: UICollectionView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//         return fetchResultsController.sections?.count ?? 1
//    }


//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//
//        if let sectionInfo = self.fetchResultsController.sections?[section] {
//            print("Count = \(sectionInfo.numberOfObjects)")
//            return sectionInfo.numberOfObjects
//        }
//        return 5
//
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoViewerCollectionViewCell", for: indexPath) as! PhotoViewerCollectionViewCell
//
//        let photo = fetchResultsController.object(at: indexPath)
//        cell.coreConfig(photo: photo, pin: pin)
//
//        return cell
//    }
//
//
//
//   override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//        delegate?.delectedSelectedCell(hasSelection: true)
//
//        let selectedPhoto = fetchResultsController.object(at: indexPath)
//
//        selectedPhotos.append(selectedPhoto)
//
//        print("selectedCount = \(selectedPhotos.count)")
//
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//
//        if collectionView.indexPathsForSelectedItems?.count == 0 {
//            delegate?.delectedSelectedCell(hasSelection: false)
//        }
//
//         let deselectedPhoto = fetchResultsController.object(at: indexPath)
//
//        guard let deselectedPhotoIndex = selectedPhotos.firstIndex(of: deselectedPhoto) else { return }
//
//        selectedPhotos.remove(at: deselectedPhotoIndex)
//          print("selectedCount = \(selectedPhotos.count)")
//
//    }

    
}

//extension PhotosCollectionViewController: NSFetchedResultsControllerDelegate {
//
//    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        insertedIndexPaths = [IndexPath]()
//        deletedIndexPaths = [IndexPath]()
//        updatedIndexPaths = [IndexPath]()
//    }
//
//    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        collectionView!.performBatchUpdates({ () -> Void in
//
//            let _ = self.insertedIndexPaths.map{ self.collectionView!.insertItems(at: [$0])}
//            let _ = self.deletedIndexPaths.map{ self.collectionView!.deleteItems(at: [$0])}
//            let _ = self.updatedIndexPaths.map{ self.collectionView!.reloadItems(at: [$0])}
//
//        }, completion: nil)
//    }
//
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
//
//        switch (type) {
//        case .insert:
//            print("didChangenewIndexPath = \(String(describing: newIndexPath))")
//            insertedIndexPaths.append(newIndexPath!)
//
//        case .delete:
//
//           deletedIndexPaths.append(indexPath!)
//
//        case .update:
//            updatedIndexPaths.append(indexPath!)
//
//        case .move:
//            print("Move an item. We don't expect to see this in this app.")
//            break
//        @unknown default:
//            fatalError("fatalError")
//        }
//
//    }
//
//}

//extension PhotosCollectionViewController: UICollectionViewDelegateFlowLayout {
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        let dimension = (view.frame.size.width - (4 * sectionInsets.left)) / 3.0
//
//        return CGSize(width: dimension, height: dimension)
//
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return sectionInsets
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//
//        return sectionInsets.left
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return sectionInsets.left
//    }
//
//}

//extension PhotosCollectionViewController: NewCollectionDelegate {
//    func deleteSelectedCell() {
//        print("deleteSelectedCellDelegateWorks")
//        deleteOnlySelectedCell()
//    }
//
//    func clearForNewCollection() {
//        print("delegateWorks")
//        callNewCollectionAction()
//    }
//
//
//}


