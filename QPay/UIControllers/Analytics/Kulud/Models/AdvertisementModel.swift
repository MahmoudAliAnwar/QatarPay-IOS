//
//  AdvertisementModel.swift
//  kulud
//
//  Created by Hussam Elsadany on 16/05/2021.
//  Copyright © 2021 Qmobile-IT. All rights reserved.
//

struct AdvertisementModel: Codable {
    let id: Int?
    let localizedName: String?
    let nameAr, nameEn, image: String?
    let type: String?
    let typeID: String?
    let order: Int?
    let categoryID: Int?
    let collectionID, productID: Int?
    let storeID: Int?

    enum CodingKeys: String, CodingKey {
        case id, localizedName, nameAr, nameEn, image, type
        case typeID = "typeId"
        case order
        case categoryID = "categoryId"
        case collectionID = "collectionId"
        case productID = "productId"
        case storeID = "storeId"
    }
}
