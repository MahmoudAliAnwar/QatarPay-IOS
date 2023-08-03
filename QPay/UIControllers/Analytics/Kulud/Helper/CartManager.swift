//
//  CartManager.swift
//  kulud
//
//  Created by Hussam Elsadany on 16/06/2021.
//  Copyright © 2021 Qmobile-IT. All rights reserved.
//

import Foundation

struct CartManager {
    
    static let shated = CartManager()
    
    public let cartCountNotificationkey = "CartCountNotificationkey"
    
    func updateCartCount() {
        
        let request = CartApiBuilder.getShoppingCart
        Network.shared.request(request: request) { (result: KuludResult<ApiResponse<CartDataModel>>) in
            switch result {
            case .success(let response):
                let count = response.responseObject?.shoppings?.count ?? 0
                NotificationCenter.default.post(name: Notification.Name(cartCountNotificationkey), object: count)
            case .failure(_):
                break
            }
        }
    }
}
