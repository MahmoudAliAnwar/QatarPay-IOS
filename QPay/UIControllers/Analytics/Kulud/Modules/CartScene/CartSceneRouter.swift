//
//  CartSceneRouter.swift
//  kulud
//
//  Created by Hussam Elsadany on 10/03/2021.
//  Copyright (c) 2021 Qmobile-IT. All rights reserved.
//

protocol CartSceneRoutingLogic: AnyObject {
    typealias Controller = CartSceneDisplayView & CartViewController
    
    func routeToShippingAddressPage(cartModel: CartModel)
    func routeToWishList()
    func routeToOrders()
}

class CartSceneRouter {

    // MARK: Stored Properties
    var cartViewController: Controller?

    // MARK: Initializers
    required init(controller: Controller?) {
        self.cartViewController = controller
    }
}

extension CartSceneRouter: CartSceneRoutingLogic {
    
    func routeToShippingAddressPage(cartModel: CartModel) {
        let viewController = ShippingAddressSceneConfigurator.configure()
        viewController.cartModel = cartModel
        viewController.createOrderCompletion = { response in
            self.cartViewController?.viewDidLoad()
            CartManager.shated.updateCartCount()
            NotificationCenter.default.post(name: .updateHomeData, object: nil)
            self.cartViewController?.showSuccessMessage(response.sucessMessage ?? "Order Created Successfully")
        }
        self.cartViewController?.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func routeToWishList() {
        let viewController = WishListSceneConfigurator.configure()
        self.cartViewController?.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func routeToOrders() {
        let viewController = OrdersSceneConfigurator.configure()
        self.cartViewController?.navigationController?.pushViewController(viewController, animated: true)
    }

}
