//
//  CartSceneModels.swift
//  kulud
//
//  Created by Hussam Elsadany on 10/03/2021.
//  Copyright (c) 2021 Qmobile-IT. All rights reserved.
//

enum CartScene {
    enum Product { }
    enum Cart { }
}

extension CartScene.Product {
    struct Product {
        let name: String
        let desc: String
        let isWishList: Bool
        let price: String
        let image: String?
        let images: [String]
        let count: Int
        let quantity: Int
    }
    
    struct ViewModel {
        let products: [Product]
    }
}

extension CartScene.Cart {
    struct Cart {
        let subTotal: String
        let shipment: String
        let discount: String
        let tax: String
        let total: String
    }
    
    struct ViewModel {
        let cart: Cart
    }
}
