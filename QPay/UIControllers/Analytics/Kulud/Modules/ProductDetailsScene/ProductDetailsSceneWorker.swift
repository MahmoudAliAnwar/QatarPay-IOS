//
//  ProductDetailsSceneWorker.swift
//  kulud
//
//  Created by Hussam Elsadany on 29/05/2021.
//  Copyright © 2021 Qmobile-IT. All rights reserved.
//

struct ProductDetailsSceneWorker {
    
    func getProductDetails(productId: Int,
                           success: @escaping(ProductModel?) -> Void,
                           failure: @escaping(Error) -> Void) {
        let request = ProductApiBuilder.getProductDetails(productId: productId)
        Network.shared.request(request: request) { (result: KuludResult<ApiResponse<SingleProductDetailsModel>>) in
            switch result {
            case .success(let response):
                success(response.responseObject?.products)
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
    
    func updateCart(productId: Int, quantity: Int,
                    completion: @escaping(Int) -> Void) {
        let request = CartApiBuilder.updateCart(productId: productId, quantity: quantity)
        Network.shared.request(request: request) { (statusCode, result: KuludResult<ApiResponse<CartDataModel>>) in
            completion(statusCode)
        }
    }
}
