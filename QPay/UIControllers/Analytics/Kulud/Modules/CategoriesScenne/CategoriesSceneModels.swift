//
//  CategoriesSceneModels.swift
//  kulud
//
//  Created by Hussam Elsadany on 27/03/2021.
//  Copyright (c) 2021 Qmobile-IT. All rights reserved.
//

enum CategoriesScene {
    enum Category { }
    enum Products { }
}

extension CategoriesScene.Products {
    struct Product {
        let name: String
        let desc: String
        let isWishList: Bool
        let price: String
        let image: String?
        let images: [String]
    }
    
    struct ViewModel {
        let products: [Product]
    }
}

extension CategoriesScene.Category {
    struct Category {
        let name: String
    }
    
    struct ViewModel {
        let Category: Category
    }
}
