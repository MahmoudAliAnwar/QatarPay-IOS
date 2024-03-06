//
//  WishListSceneInteractor.swift
//  kulud
//
//  Created by Hussam Elsadany on 05/06/2021.
//  Copyright (c) 2021 Qmobile-IT. All rights reserved.
//

protocol WishListSceneBusinessLogic: AnyObject {
    func getWishListData()
    func removeItemFromWishList(index: Int)
    func addItemToCart(index: Int)
}

protocol WishListSceneDataStore: AnyObject {
    var products: [ShoppingModel] { get set }
}

class WishListSceneInteractor: WishListSceneBusinessLogic, WishListSceneDataStore {

    // MARK: Stored Properties
    let presenter: WishListScenePresentationLogic

    var products: [ShoppingModel] = []
    
    private let worker = WishListSceneWorker()
    
    // MARK: Initializers
    required init(presenter: WishListScenePresentationLogic) {
        self.presenter = presenter
    }
}

extension WishListSceneInteractor {

    func getWishListData() {
        self.worker.getWishListDetails { products in
            guard let products = products else {
                return
            }
            self.products = products
            self.presenter.presentProducts(products: self.products)
        } failure: { error in
            self.presenter.presentError(error: error)
        }
    }
    
    func removeItemFromWishList(index: Int) {
        guard let productId = self.products[index].product?.id else {
            return
        }
        self.worker.addRemoveProductFromWishList(productId: productId) { statusCode in
            if statusCode == 200 {
                self.products.remove(at: index)
                self.presenter.presentProducts(products: self.products)
            }
        }
    }
    
    func addItemToCart(index: Int) {
        guard let productId = self.products[index].product?.id else {
            return
        }
        self.worker.addToCart(productId: productId, quantity: 1) { statusCode in
            if statusCode == 200 {
                self.products.remove(at: index)
                self.presenter.presentProducts(products: self.products)
                self.removeItemSilent(productId: productId)
            }
        }
    }
}

private extension WishListSceneInteractor {
    func removeItemSilent(productId: Int) {
        self.worker.addRemoveProductFromWishList(productId: productId) { statusCode in
            if statusCode == 200 {
                // DO Something Here...
            }
        }
    }
}
