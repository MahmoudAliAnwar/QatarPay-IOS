//
//  WishListSceneSceneModels.swift
//  kulud
//
//  Created by Hussam Elsadany on 05/06/2021.
//  Copyright (c) 2021 Qmobile-IT. All rights reserved.
//

enum WishListSceneScene {
    enum Products { }
}

extension WishListSceneScene.Products {
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
