//
//  PaymentSceneConfigurator.swift
//  kulud
//
//  Created by Hussam Elsadany on 07/06/2021.
//  Copyright (c) 2021 Qmobile-IT. All rights reserved.
//

class PaymentSceneConfigurator {

    static func configure() -> PaymentViewController {
        let viewController = PaymentViewController()
        let presenter = PaymentScenePresenter(displayView: viewController)
        let interactor = PaymentSceneInteractor(presenter: presenter)
        let router = PaymentSceneRouter(controller: viewController)
        viewController.interactor = interactor
        viewController.dataStore = interactor
        viewController.router = router
        viewController.viewStore = presenter
        return viewController
    }
}
