//
//  OrdersSceneRouter.swift
//  kulud
//
//  Created by Hussam Elsadany on 09/06/2021.
//  Copyright (c) 2021 Qmobile-IT. All rights reserved.
//

protocol OrdersSceneRoutingLogic: AnyObject {
    typealias Controller = OrdersSceneDisplayView & OrdersViewController
    
    func routeToCart()
    func routeToWishList()
}

class OrdersSceneRouter {

    // MARK: Stored Properties
    var viewController: Controller?

    // MARK: Initializers
    required init(controller: Controller?) {
        self.viewController = controller
    }
}

extension OrdersSceneRouter: OrdersSceneRoutingLogic {

    func routeToCart() {
        let viewController = CartSceneConfigurator.configure()
        self.viewController?.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func routeToWishList() {
        let viewController = WishListSceneConfigurator.configure()
        self.viewController?.navigationController?.pushViewController(viewController, animated: true)
    }
}
