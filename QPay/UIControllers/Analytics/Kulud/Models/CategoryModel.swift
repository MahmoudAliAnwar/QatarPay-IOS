//
//  CategoryModel.swift
//  kulud
//
//  Created by Hussam Elsadany on 16/05/2021.
//  Copyright © 2021 Qmobile-IT. All rights reserved.
//

struct CategoryModel: Codable {
    let id: Int?
    let nameAr: String?
    let parentID: Int?
    let nameEn: String?
    let iconImage: String?
    let localizedName, image: String?
    var products: [ProductModel]?
    var subCategories: [CategoryModel]?
}
