//
//  WishListScenePresenter.swift
//  kulud
//
//  Created by Hussam Elsadany on 05/06/2021.
//  Copyright (c) 2021 Qmobile-IT. All rights reserved.
//

protocol WishListScenePresentationLogic: AnyObject {
    func presentProducts(products: [ShoppingModel])
    func presentError(error: Error)
}

protocol WishListSceneViewStore: AnyObject {
    var products: WishListSceneScene.Products.ViewModel? { get set }
}

class WishListScenePresenter: WishListScenePresentationLogic, WishListSceneViewStore {

    // MARK: Stored Properties
    weak var displayView: WishListSceneDisplayView?

    var products: WishListSceneScene.Products.ViewModel? = nil
    
    // MARK: Initializers
    required init(displayView: WishListSceneDisplayView) {
        self.displayView = displayView
    }
}

extension WishListScenePresenter {
    
    func presentProducts(products: [ShoppingModel]) {
        
        var productList = [WishListSceneScene.Products.Product]()
        products.forEach {
            let productData = $0.product
            let product = WishListSceneScene.Products.Product(name: productData?.localizedName ?? "",
                                                           desc: productData?.localizedDescription ?? "",
                                                           isWishList: productData?.isWishList ?? false,
                                                           price: String(format: "%.2f", productData?.price ?? 0),
                                                           image: productData?.image,
                                                           images: productData?.productsImages?.compactMap{$0.image} ?? [])
            productList.append(product)
        }
        
        self.products = WishListSceneScene.Products.ViewModel(products: productList)
        self.displayView?.displayProducts(viewModel: self.products!)
    }
    
    func presentError(error: Error) {
        self.displayView?.displayError(message: error.localizedDescription)
    }
}
