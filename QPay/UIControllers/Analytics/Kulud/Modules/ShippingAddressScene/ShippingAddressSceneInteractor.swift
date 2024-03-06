//
//  ShippingAddressSceneInteractor.swift
//  kulud
//
//  Created by Hussam Elsadany on 06/06/2021.
//  Copyright (c) 2021 Qmobile-IT. All rights reserved.
//

protocol ShippingAddressSceneBusinessLogic: AnyObject {

}

protocol ShippingAddressSceneDataStore: AnyObject {

}

class ShippingAddressSceneInteractor: ShippingAddressSceneBusinessLogic, ShippingAddressSceneDataStore {

    // MARK: Stored Properties
    let presenter: ShippingAddressScenePresentationLogic

    // MARK: Initializers
    required init(presenter: ShippingAddressScenePresentationLogic) {
        self.presenter = presenter
    }
}

extension ShippingAddressSceneInteractor {

}
