//
//  PaymentScenePresenter.swift
//  kulud
//
//  Created by Hussam Elsadany on 07/06/2021.
//  Copyright (c) 2021 Qmobile-IT. All rights reserved.
//

protocol PaymentScenePresentationLogic: AnyObject {

}

protocol PaymentSceneViewStore: AnyObject {

}

class PaymentScenePresenter: PaymentScenePresentationLogic, PaymentSceneViewStore {

    // MARK: Stored Properties
    weak var displayView: PaymentSceneDisplayView?

    // MARK: Initializers
    required init(displayView: PaymentSceneDisplayView) {
        self.displayView = displayView
    }
}

extension PaymentScenePresenter {

}
