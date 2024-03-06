//
//  ProductDetailsSceneInteractor.swift
//  kulud
//
//  Created by Hussam Elsadany on 10/03/2021.
//  Copyright (c) 2021 Qmobile-IT. All rights reserved.
//

protocol ProductDetailsSceneBusinessLogic: AnyObject {
    func getProductDetails()
    func addRemoveProductToWithList()
    func addToCart()
    func updateProductQuantity(quantity: Int)
}

protocol ProductDetailsSceneDataStore: AnyObject {
    var productDetails: ProductModel? { get set }
    var productQuantoty: Int { get set }
}

class ProductDetailsSceneInteractor: ProductDetailsSceneBusinessLogic, ProductDetailsSceneDataStore {

    // MARK: Stored Properties
    let presenter: ProductDetailsScenePresentationLogic

    private let worker = ProductDetailsSceneWorker()
    
    var productDetails: ProductModel?
    var productQuantoty: Int = 1
    
    // MARK: Initializers
    required init(presenter: ProductDetailsScenePresentationLogic) {
        self.presenter = presenter
    }
}

extension ProductDetailsSceneInteractor {
    
    func getProductDetails() {
        guard let product = self.productDetails, let productId = self.productDetails?.id else {
            return
        }
        self.presenter.presentProduct(product: product)
        self.worker.getProductDetails(productId: productId) { product in
            guard let product = product else {
                return
            }
            self.productDetails = product
            self.presenter.presentProduct(product: product)
            CartManager.shated.updateCartCount()
        } failure: { error in
            self.presenter.presentError(error: error)
        }
    }
    
    func addRemoveProductToWithList() {
        guard let productId = self.productDetails?.id else {
            return
        }
        
        self.worker.addRemoveProductFromWishList(productId: productId) { statusCode in
            if statusCode == 200 {
                self.productDetails?.isWishList?.toggle()
                self.presenter.presentProduct(product: self.productDetails!)
            }
        }
    }
    
    func addToCart() {
        guard let productId = self.productDetails?.id else {
            return
        }
        
        self.worker.addToCart(productId: productId,
                              quantity: self.productQuantoty) { statusCode in
            if statusCode == 200 {
                self.presenter.presentAddToCartSuccessfully()
                self.getProductDetails()
            } else {
                self.presenter.presentError(error: nil)
            }
        }
    }
    
    func updateProductQuantity(quantity: Int) {
        guard let productId = self.productDetails?.id else {
            return
        }
        
        self.worker.updateCart(productId: productId, quantity: quantity) { statusCode in
            if statusCode == 200 {
                self.getProductDetails()
            }
        }
    }
}
