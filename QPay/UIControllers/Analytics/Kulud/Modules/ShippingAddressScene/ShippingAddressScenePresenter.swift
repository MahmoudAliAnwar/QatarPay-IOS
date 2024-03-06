//
//  ShippingAddressScenePresenter.swift
//  kulud
//
//  Created by Hussam Elsadany on 06/06/2021.
//  Copyright (c) 2021 Qmobile-IT. All rights reserved.
//

protocol ShippingAddressScenePresentationLogic: AnyObject {

}

protocol ShippingAddressSceneViewStore: AnyObject {

}

class ShippingAddressScenePresenter: ShippingAddressScenePresentationLogic, ShippingAddressSceneViewStore {

    // MARK: Stored Properties
    weak var displayView: ShippingAddressSceneDisplayView?

    // MARK: Initializers
    required init(displayView: ShippingAddressSceneDisplayView) {
        self.displayView = displayView
    }
}

extension ShippingAddressScenePresenter {

}
