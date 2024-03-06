//
//  CartSceneInteractor.swift
//  kulud
//
//  Created by Hussam Elsadany on 10/03/2021.
//  Copyright (c) 2021 Qmobile-IT. All rights reserved.
//

protocol CartSceneBusinessLogic: AnyObject {
    func getCartDetails()
    func updateProduct(productId: Int, quantity: Int)
}

protocol CartSceneDataStore: AnyObject {
    var cartDetails: CartDataModel? { get set }
}

class CartSceneInteractor: CartSceneBusinessLogic, CartSceneDataStore {
    
    // MARK: Stored Properties
    let presenter: CartScenePresentationLogic

    private let worker = CartSceneWorker()
    
    public var cartDetails: CartDataModel? = nil
    
    // MARK: Initializers
    required init(presenter: CartScenePresentationLogic) {
        self.presenter = presenter
    }
}

extension CartSceneInteractor {
    
    func getCartDetails() {
        
        self.worker.getCartDetails { cartData in
            guard let cartData = cartData else {
                return
            }
            self.cartDetails = cartData
            self.presenter.presentCartData(cartData: cartData)
        } failure: { error in
            self.presenter.presentError(error: error)
        }
    }
    
    func updateProduct(productId: Int, quantity: Int) {
        self.worker.updateCart(productId: productId, quantity: quantity) { cartData in
            guard let cartData = cartData else {
                return
            }
            self.cartDetails = cartData
            self.presenter.presentCartData(cartData: cartData)
            CartManager.shated.updateCartCount()
        } failure: { error in
            self.presenter.presentError(error: error)
        }
    }
}
