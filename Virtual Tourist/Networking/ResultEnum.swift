//
//  ResultEnum.swift
//  OnTheMap
//
//  Created by Sukumar Anup Sukumaran on 27/08/18.
//  Copyright © 2018 TechTonic. All rights reserved.
//

import Foundation

enum Result <T> {
    case Success(T)
    case Error(String)
}
