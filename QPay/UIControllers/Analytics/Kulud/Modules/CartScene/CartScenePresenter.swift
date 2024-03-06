//
//  CartScenePresenter.swift
//  kulud
//
//  Created by Hussam Elsadany on 10/03/2021.
//  Copyright (c) 2021 Qmobile-IT. All rights reserved.
//

protocol CartScenePresentationLogic: AnyObject {
    func presentCartData(cartData: CartDataModel)
    func presentError(error: Error)
}

protocol CartSceneViewDataStore: AnyObject {
    var products: CartScene.Product.ViewModel? { get set }
    var cart: CartScene.Cart.ViewModel? { get set }
}

class CartScenePresenter: CartScenePresentationLogic, CartSceneViewDataStore {

    // MARK: Stored Properties
    weak var displayView: CartSceneDisplayView?

    var products: CartScene.Product.ViewModel? = nil
    
    var cart: CartScene.Cart.ViewModel? = nil
    
    // MARK: Initializers
    required init(displayView: CartSceneDisplayView) {
        self.displayView = displayView
    }
}

extension CartScenePresenter {

    func presentCartData(cartData: CartDataModel) {
        
        var products = [CartScene.Product.Product]()
        cartData.shoppings?.forEach {
            guard let productData = $0.product else { return }
            let product = CartScene.Product.Product(name: productData.localizedName ?? "",
                                                    desc: productData.localizedDescription ?? "",
                                                    isWishList: productData.isWishList ?? false,
                                                    price: String(format: "%.2f", productData.price ?? 0),
                                                    image: productData.image,
                                                    images: productData.productsImages?.compactMap{$0.image} ?? [],
                                                    count: productData.count ?? 1,
                                                    quantity: $0.quantity ?? 1)
            products.append(product)
        }
        
        let cartDetails = cartData.cart
        let cart = CartScene.Cart.Cart(subTotal: String(format: "QAR %.2f", cartDetails?.subTotal ?? 0),
                                       shipment: String(format: "QAR %.2f", cartDetails?.shipment ?? 0),
                                       discount: String(format: "QAR %.2f", cartDetails?.discount ?? 0),
                                       tax: String(format: "QAR %.2f", cartDetails?.tax ?? 0),
                                       total: String(format: "QAR %.2f", cartDetails?.total ?? 0))
        
        self.products = CartScene.Product.ViewModel(products: products)
        self.cart = CartScene.Cart.ViewModel(cart: cart)
        self.displayView?.displayProducts(viewModel: self.products!)
        guard let cartModel = cartData.cart else { return }
        self.displayView?.displayCart(viewModel: self.cart!, cartModel: cartModel)
    }
    
    func presentError(error: Error) {
        self.displayView?.displayError(message: error.localizedDescription)
    }
}
