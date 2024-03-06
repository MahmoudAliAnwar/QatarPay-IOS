//
//  
//  BaseInfo.swift
//  QPay
//
//  Created by Mohammed Hamad on 06/06/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//
//
import Foundation
import UIKit

// MARK: - Base Info Model
struct BaseInfoModel {
    
    var tabs: [BaseInfoTabModel]
    var data: [BaseInfoDataModel]
}

// MARK: - Base Info Tab Model
struct BaseInfoTabModel: Equatable {
    
    var id         : Int
    var title      : String
    var isSelected : Bool = false
}

// MARK: - Base Info Data Model
struct BaseInfoDataModel {
    
    var id          : Int
    var imageURL    : String
    var isFavorite  : Bool
    var name        : String
    var office      : String
    var workingFrom : String
    var workingTo   : String
    var email       : String
    var website     : String
    var rate        : Double
    var images      : [BaseInfoImageModel]
    var mobile      : String
    var locationURL : String
}

// MARK: - Base Info Image Model
struct BaseInfoImageModel {
    
    var imageURL: String
}
