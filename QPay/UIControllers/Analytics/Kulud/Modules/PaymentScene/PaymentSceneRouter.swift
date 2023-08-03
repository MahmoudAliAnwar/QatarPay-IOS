//
//  PaymentSceneRouter.swift
//  kulud
//
//  Created by Hussam Elsadany on 07/06/2021.
//  Copyright (c) 2021 Qmobile-IT. All rights reserved.
//

protocol PaymentSceneRoutingLogic: AnyObject {
    typealias Controller = PaymentSceneDisplayView & PaymentViewController
}

class PaymentSceneRouter {

    // MARK: Stored Properties
    var viewController: Controller?

    // MARK: Initializers
    required init(controller: Controller?) {
        self.viewController = controller
    }
}

extension PaymentSceneRouter: PaymentSceneRoutingLogic {

}
