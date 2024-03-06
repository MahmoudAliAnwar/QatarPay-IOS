//
//  ProductDetailsScenePresenter.swift
//  kulud
//
//  Created by Hussam Elsadany on 10/03/2021.
//  Copyright (c) 2021 Qmobile-IT. All rights reserved.
//

protocol ProductDetailsScenePresentationLogic: AnyObject {
    func presentProduct(product: ProductModel)
    func presentError(error: Error?)
    func presentAddToCartSuccessfully()
}

protocol ProductDetailsSceneViewDataStore {
    var product: ProductDetailsScene.Product.ViewModel? { get set }
}

class ProductDetailsScenePresenter: ProductDetailsScenePresentationLogic, ProductDetailsSceneViewDataStore {
    
    // MARK: Stored Properties
    weak var displayView: ProductDetailsSceneDisplayView?

    var product: ProductDetailsScene.Product.ViewModel?
    
    // MARK: Initializers
    required init(displayView: ProductDetailsSceneDisplayView) {
        self.displayView = displayView
    }
}

extension ProductDetailsScenePresenter {
    
    func presentProduct(product: ProductModel) {
        
        let product = ProductDetailsScene.Product.Product(name: product.localizedName ?? "",
                                                          desc: product.localizedDescription ?? "",
                                                          isWishList: product.isWishList ?? false,
                                                          price: String(format: "%.2f", product.price ?? 0),
                                                          image: product.image,
                                                          images: product.productsImages?.compactMap{$0.image} ?? [],
                                                          count: product.count ?? 1,
                                                          isCart: product.isCart ?? false,
                                                          quantity: product.quantity ?? 0)
        self.product = ProductDetailsScene.Product.ViewModel(product: product)
        self.displayView?.displayProduct(viewModel: self.product!)
    }
    
    func presentError(error: Error?) {
        guard let error = error else {
            self.displayView?.displayError(message: "Something Wrong Happen!")
            return
        }
        self.displayView?.displayError(message: error.localizedDescription)
    }
    
    func presentAddToCartSuccessfully() {
        self.displayView?.displayAddedToCart()
    }
}
