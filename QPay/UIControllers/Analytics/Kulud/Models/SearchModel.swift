//
//  SearchModel.swift
//  kulud
//
//  Created by Hussam Elsadany on 06/06/2021.
//  Copyright © 2021 Qmobile-IT. All rights reserved.
//

import Foundation

struct SearchModel: Codable {
    let products: [ProductModel]?
    let subCategories: [CategoryModel]?
}
