//
//  StoreModel.swift
//  kulud
//
//  Created by Hussam Elsadany on 16/05/2021.
//  Copyright © 2021 Qmobile-IT. All rights reserved.
//

struct StoreModel: Codable {
    let collections: [CollectionModel]?
    let advertisement: [AdvertisementModel]?
    let categories: [CategoryModel]?
}
