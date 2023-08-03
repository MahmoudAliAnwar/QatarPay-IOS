//
//  HomeSceneWorker.swift
//  kulud
//
//  Created by Hussam Elsadany on 16/05/2021.
//  Copyright © 2021 Qmobile-IT. All rights reserved.
//

struct HomeSceneWorker {
    
    func getStoreDetails(success: @escaping(StoreModel?) -> Void,
                         failure: @escaping(Error) -> Void) {
        let request = StoreApiBuilder.getStoreDetails(storeId: Constants.STOREID)
        Network.shared.request(request: request) { (result: KuludResult<ApiResponse<StoreModel>>) in
            switch result {
            case .success(let response):
                success(response.responseObject)
            case .failure(let error):
                failure(error)
            }
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
