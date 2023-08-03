//
//  CollectionModel.swift
//  kulud
//
//  Created by Hussam Elsadany on 16/05/2021.
//  Copyright © 2021 Qmobile-IT. All rights reserved.
//

import Foundation

struct CollectionModel: Codable {
    let id, order: Int?
    let localizedName, nameAr, nameEn: String?
    let image: String?
    var products: [ProductModel]?
    let storeID: String?
    let type: Int?

    enum CodingKeys: String, CodingKey {
        case id, order, localizedName, nameAr, nameEn, image, products
        case storeID = "storeId"
        case type
    }
}
