//
//  ShippingAddressSceneRouter.swift
//  kulud
//
//  Created by Hussam Elsadany on 06/06/2021.
//  Copyright (c) 2021 Qmobile-IT. All rights reserved.
//

protocol ShippingAddressSceneRoutingLogic: AnyObject {
    typealias Controller = ShippingAddressSceneDisplayView & ShippingAddressViewController
    
    func routeToPayment()
}

class ShippingAddressSceneRouter {

    // MARK: Stored Properties
    var viewController: Controller?

    // MARK: Initializers
    required init(controller: Controller?) {
        self.viewController = controller
    }
}

extension ShippingAddressSceneRouter: ShippingAddressSceneRoutingLogic {

    func routeToPayment() {
        let viewController = PaymentSceneConfigurator.configure()
        self.viewController?.navigationController?.pushViewController(viewController, animated: true)
    }
}
