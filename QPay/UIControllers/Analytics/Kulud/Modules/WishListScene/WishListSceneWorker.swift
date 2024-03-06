//
//  WishListSceneWorker.swift
//  kulud
//
//  Created by Hussam Elsadany on 05/06/2021.
//  Copyright © 2021 Qmobile-IT. All rights reserved.
//

import Foundation

struct WishListSceneWorker {
    
    func getWishListDetails(success: @escaping([ShoppingModel]?) -> Void,
                            failure: @escaping(Error) -> Void) {
        
        let request = ProductApiBuilder.getWishList
        Network.shared.request(request: request) { (result: KuludResult<ApiResponse<[ShoppingModel]>>) in
            switch result {
            case .success(let response):
                success(response.responseObject)
            case .failure(let error):
                failure(error)
            }
        }
    }
    
    func addRemoveProductFromWishList(productId: Int,
                                      completion: @escaping(Int) -> Void) {
        let request = ProductApiBuilder.addRemoveToWithList(productId: productId)
        Network.shared.request(request: request) { (statusCode, result: KuludResult<ApiResponse<SingleProductDetailsModel>>) in
            completion(statusCode)
        }
    }
    
    func addToCart(productId: Int, quantity: Int,
                   completion: @escaping(Int) -> Void) {
        let request = CartApiBuilder.addToCart(productId: productId, quantity: quantity)
        Network.shared.request(request: request) { (statusCode, result: KuludResult<ApiResponse<SingleProductDetailsModel>>) in
            completion(statusCode)
        }
    }
}
