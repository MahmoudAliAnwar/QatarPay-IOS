//
//  OrdersScenePresenter.swift
//  kulud
//
//  Created by Hussam Elsadany on 09/06/2021.
//  Copyright (c) 2021 Qmobile-IT. All rights reserved.
//

protocol OrdersScenePresentationLogic: AnyObject {

}

protocol OrdersSceneViewStore: AnyObject {

}

class OrdersScenePresenter: OrdersScenePresentationLogic, OrdersSceneViewStore {

    // MARK: Stored Properties
    weak var displayView: OrdersSceneDisplayView?

    // MARK: Initializers
    required init(displayView: OrdersSceneDisplayView) {
        self.displayView = displayView
    }
}

extension OrdersScenePresenter {

}
