//
//  CartSceneWorker.swift
//  kulud
//
//  Created by Hussam Elsadany on 05/06/2021.
//  Copyright © 2021 Qmobile-IT. All rights reserved.
//

import Foundation

struct CartSceneWorker {
    
    func getCartDetails(success: @escaping(CartDataModel?) -> Void,
                         failure: @escaping(Error) -> Void) {
        
        let request = CartApiBuilder.getShoppingCart
        Network.shared.request(request: request) { (result: KuludResult<ApiResponse<CartDataModel>>) in
            switch result {
            case .success(let response):
                success(response.responseObject)
            case .failure(let error):
                failure(error)
            }
        }
    }
    
    func updateCart(productId: Int, quantity: Int,
                    success: @escaping(CartDataModel?) -> Void,
                    failure: @escaping(Error) -> Void) {
        
        let request = CartApiBuilder.updateCart(productId: productId, quantity: quantity)
        Network.shared.request(request: request) { (result: KuludResult<ApiResponse<CartDataModel>>) in
            switch result {
            case .success(let response):
                success(response.responseObject)
            case .failure(let error):
                failure(error)
            }
        }
    }
}
