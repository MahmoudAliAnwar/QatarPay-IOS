//
//  NetworkPaths.swift
//  kulud
//
//  Created by Hussam Elsadany on 16/05/2021.
//  Copyright © 2021 Qmobile-IT. All rights reserved.
//

import Foundation

enum NetworkPaths {
    enum Store { }
    enum Cart { }
    enum Product { }
}

extension NetworkPaths.Store {
    
    static let storeDetails    = "Store/GetShopDetails/{0}"
    static let categoryDetails = "Store/GetStoreCatDetails/{0}"
    static let search          = "Store/SerachProductsOfStoreCat"
}

extension NetworkPaths.Cart {
    static let getCart    = "Cart/ShoppingCart"
    static let addToCart  = "Cart/AddToCart/{0}/{1}"
    static let updateCart = "Cart/UpdateCart/{0}/{1}"
}

extension NetworkPaths.Product {
    static let productDetails    = "Product/GetProductsDetails/{0}"
    static let addRemoveWithList = "Product/AddOrRemoveFromWishList/{0}"
    static let withList          = "Product/GetWishList"
}
