//
//  WishListSceneRouter.swift
//  kulud
//
//  Created by Hussam Elsadany on 05/06/2021.
//  Copyright (c) 2021 Qmobile-IT. All rights reserved.
//

protocol WishListSceneRoutingLogic: AnyObject {
    typealias Controller = WishListSceneDisplayView & WishListViewController
    
    func routeToCart()
    func routeToOrders()
}

class WishListSceneRouter {

    // MARK: Stored Properties
    var viewController: Controller?

    // MARK: Initializers
    required init(controller: Controller?) {
        self.viewController = controller
    }
}

extension WishListSceneRouter: WishListSceneRoutingLogic {

    func routeToCart() {
        let viewController = CartSceneConfigurator.configure()
        self.viewController?.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func routeToOrders() {
        let viewController = OrdersSceneConfigurator.configure()
        self.viewController?.navigationController?.pushViewController(viewController, animated: true)
    }
}
