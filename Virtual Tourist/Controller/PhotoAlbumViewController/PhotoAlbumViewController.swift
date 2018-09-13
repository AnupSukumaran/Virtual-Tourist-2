//
//  PhotoAlbumViewController.swift
//  Virtual Tourist
//
//  Created by Sukumar Anup Sukumaran on 10/09/18.
//  Copyright © 2018 TechTonic. All rights reserved.
//

import UIKit
import CoreData

class PhotoAlbumViewController: UIViewController {
    
    
    var lat: Double?
    var long: Double?
    var zlat: Double?
    var zlong: Double?
    
    var dataController: DataController!
    let sharedFunc = CommonFunc.shared
    var pin:Pins!
    var fetchResultsController: NSFetchedResultsController<Photo>!
    
    @IBOutlet weak var collectionViewer: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateFlowLayout(view.frame.size)
        
        callingAPI()
       // setupFetchResultsControllerMethod()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        fetchResultsController = nil
    }
    
//    fileprivate func setupFetchResultsControllerMethod() {
//        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
//        let predicate = NSPredicate(format: "pin == %@", pin)
//        fetchRequest.predicate = predicate
//        let sortDescriptor = NSSortDescriptor(key: "image", ascending: false)
//        fetchRequest.sortDescriptors = [sortDescriptor]
//        
//        fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: "\(pin.latitude)")
//        
//        fetchResultsController.delegate = self
//        
//        do {
//            try fetchResultsController.performFetch()
//        } catch let error {
//             callingAPI()
//            print("Error = \(error.localizedDescription )")
//        }
//    }
    
    func callingAPI() {
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
    
    
    @IBAction func newCollection(_ sender: Any) {
        callingAPI()
    }
    

}

extension PhotoAlbumViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return fetchResultsController.sections?.count ?? 1
//    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      // print("Count = \(sharedFunc.galleryModel.count)")
        return sharedFunc.galleryModel.count
       // return fetchResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoViewerCollectionViewCell", for: indexPath) as! PhotoViewerCollectionViewCell
        
        
        cell.config(galleryData: sharedFunc.galleryModel[indexPath.row])
        
        return cell
    }
    
    
}

//extension PhotoAlbumViewController: NSFetchedResultsControllerDelegate {
//
//    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        collectionViewer.be
//    }
//
//    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        tableView.endUpdates()
//    }
//
//
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
//        let indexSet = IndexSet(integer: sectionIndex)
//
//        switch type {
//        case .insert: tableView.insertSections(indexSet, with: .fade)
//        case .delete: tableView.deleteSections(indexSet, with: .fade)
//        case .update: fatalError("Not possible")
//        default:
//            break
//        }
//    }
//
//
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
//
//        switch type {
//        case .insert:
//            tableView.insertRows(at: [newIndexPath!], with: .fade)
//        case .delete:
//            tableView.deleteRows(at: [indexPath!], with: .fade)
//        case .update:
//            tableView.reloadRows(at: [indexPath!], with: .fade)
//        case .move:
//            tableView.moveRow(at: indexPath!, to: newIndexPath!)
//        }
//
//    }
//
//}
