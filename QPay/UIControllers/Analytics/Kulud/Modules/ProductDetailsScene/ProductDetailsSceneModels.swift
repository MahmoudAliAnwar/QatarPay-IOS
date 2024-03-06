//
//  ProductDetailsSceneModels.swift
//  kulud
//
//  Created by Hussam Elsadany on 10/03/2021.
//  Copyright (c) 2021 Qmobile-IT. All rights reserved.
//

enum ProductDetailsScene {
    enum Product { }
}

extension ProductDetailsScene.Product {
    
    struct Product {
        let name: String
        let desc: String
        let isWishList: Bool
        let price: String
        let image: String?
        let images: [String]
        let count: Int
        let isCart: Bool
        let quantity: Int
    }
    
    struct ViewModel {
        let product: Product
    }
}
