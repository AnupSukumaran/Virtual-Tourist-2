//
//  AlertView.swift
//  OnTheMap
//
//  Created by Sukumar Anup Sukumaran on 28/08/18.
//  Copyright © 2018 TechTonic. All rights reserved.
//

import Foundation
import UIKit

class AlertView: NSObject {
    
    static func showAlert(message: String, UIVIews: UIViewController) {
        
        let alertCrt = UIAlertController(title: "", message: message, preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertCrt.addAction(action1)
    
        //return alertCrt
        UIVIews.present(alertCrt, animated: true, completion: nil)
        
    }
    
//    static func showAlert2(message: String, UIVIews: UIViewController, completionBLK: @escaping() -> ()) {
//        
//        let alertCrt = UIAlertController(title: "", message: message, preferredStyle: .alert)
//        
//        let action1 = UIAlertAction(title: "Overwrite", style: .default) { (_) in
//            completionBLK()
//        }
//        
//        let action2 = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//        
//        alertCrt.addAction(action1)
//        alertCrt.addAction(action2)
//        
//        //return alertCrt
//        UIVIews.present(alertCrt, animated: true, completion: nil)
//        
//    }
    
}
