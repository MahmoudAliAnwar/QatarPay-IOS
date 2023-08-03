//
//  CartModel.swift
//  kulud
//
//  Created by Hussam Elsadany on 05/06/2021.
//  Copyright © 2021 Qmobile-IT. All rights reserved.
//

import Foundation

struct CartDataModel: Codable {
    let shoppings: [ShoppingModel]?
    let cart: CartModel?
}

struct CartModel: Codable {
    let subTotal, shipment, discount, tax, total: Double?
}

struct ShoppingModel: Codable {
    let id, productID: Int?
    let product: ProductModel?
    let quantity, discount: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case productID = "productId"
        case product, quantity, discount
    }
}
