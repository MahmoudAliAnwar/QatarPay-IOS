//
//  ProductDetailsSceneRouter.swift
//  kulud
//
//  Created by Hussam Elsadany on 10/03/2021.
//  Copyright (c) 2021 Qmobile-IT. All rights reserved.
//

protocol ProductDetailsSceneRoutingLogic: AnyObject {
    typealias Controller = ProductDetailsSceneDisplayView & ProductDetailsViewController
    
    func routeToCart()
    func routeToWishList()
    func routeToOrders()
}

class ProductDetailsSceneRouter {

    // MARK: Stored Properties
    var viewController: Controller?

    // MARK: Initializers
    required init(controller: Controller?) {
        self.viewController = controller
    }
}

extension ProductDetailsSceneRouter: ProductDetailsSceneRoutingLogic {
    
    func routeToCart() {
        let viewController = CartSceneConfigurator.configure()
        self.viewController?.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func routeToWishList() {
        let viewController = WishListSceneConfigurator.configure()
        self.viewController?.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func routeToOrders() {
        let viewController = OrdersSceneConfigurator.configure()
        self.viewController?.navigationController?.pushViewController(viewController, animated: true)
    }
}
