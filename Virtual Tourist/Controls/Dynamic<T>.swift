//
//  Dynamic<T>.swift
//  Dado_App
//
//  Created by Manu Puthoor on 09/04/20.
//  Copyright © 2020 Manu Puthoor. All rights reserved.
//

import Foundation


class Dynamic<T> {
    typealias Listener = (T) -> ()
    var listener: Listener?
    
    func bind(_ listener: Listener?) {
        self.listener = listener
    }
    
    func bindAndFire(_ listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ v: T) {
        value = v
    }
}
