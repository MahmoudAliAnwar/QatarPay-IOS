//
//  ProductModel.swift
//  kulud
//
//  Created by Hussam Elsadany on 16/05/2021.
//  Copyright © 2021 Qmobile-IT. All rights reserved.
//

class ProductModel: Codable {
    let id: Int?
    let nameAr, nameEn, descriptionAr, descriptionEn: String?
    let localizedName, localizedDescription: String?
    let price: Double?
    let isSale, approve, isWowDeal: Bool?
    let rate, shipment, tax: Int?
    let image: String?
    let count: Int?
    let storeNameAr, storeNameEn: String?
    let storeID: String?
    let deleviry, categoryID: Int?
    let userID: String?
    var isWishList: Bool?
    let productsImages: [ProductsImageModel]?
    var isCart: Bool?
    var quantity: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, nameAr, nameEn, descriptionAr, descriptionEn, localizedName, localizedDescription, price, isSale, approve, isWowDeal, rate, shipment, tax, image, count, storeNameAr, storeNameEn
        case storeID = "storeId"
        case deleviry
        case categoryID = "categoryId"
        case userID = "userId"
        case isWishList, productsImages, isCart, quantity
    }
}

struct ProductsImageModel: Codable {
    let id: Int?
    let image: String?
}

struct SingleProductDetailsModel: Codable {
    let products: ProductModel?
}
