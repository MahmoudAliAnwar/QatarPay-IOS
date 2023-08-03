//
//  ShippingAddressSceneConfigurator.swift
//  kulud
//
//  Created by Hussam Elsadany on 06/06/2021.
//  Copyright (c) 2021 Qmobile-IT. All rights reserved.
//

class ShippingAddressSceneConfigurator {

    static func configure() -> ShippingAddressViewController {
        let viewController = ShippingAddressViewController()
        let presenter = ShippingAddressScenePresenter(displayView: viewController)
        let interactor = ShippingAddressSceneInteractor(presenter: presenter)
        let router = ShippingAddressSceneRouter(controller: viewController)
        viewController.interactor = interactor
        viewController.dataStore = interactor
        viewController.router = router
        viewController.viewStore = presenter
        return viewController
    }
}
