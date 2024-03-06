//
//  CategoriesSceneRouter.swift
//  kulud
//
//  Created by Hussam Elsadany on 27/03/2021.
//  Copyright (c) 2021 Qmobile-IT. All rights reserved.
//

protocol CategoriesSceneRoutingLogic: AnyObject {
    
    typealias Controller = CategoriesSceneDisplayView & CategoriesViewController
    
    func routeToProductDetails(_ product: ProductModel)
    func routeToCart()
    func routeToWishList()
    func routeToOrders()
    func routeToFilters(subCategories: [CategoryModel])
}

class CategoriesSceneRouter {
    
    // MARK: Stored Properties
    var viewController: Controller?

    // MARK: Initializers
    required init(controller: Controller?) {
        self.viewController = controller
    }
}

extension CategoriesSceneRouter: CategoriesSceneRoutingLogic {
    
    func routeToProductDetails(_ product: ProductModel) {
        let viewController = ProductDetailsSceneConfigurator.configure()
        viewController.dataStore.productDetails = product
        self.viewController?.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func routeToCart() {
        let viewController = CartSceneConfigurator.configure()
        self.viewController?.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func routeToWishList() {
        let viewController = WishListSceneConfigurator.configure()
        self.viewController?.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func routeToOrders() {
        let viewController = OrdersSceneConfigurator.configure()
        self.viewController?.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func routeToFilters(subCategories: [CategoryModel]) {
        let viewController = FilterSceneConfigurator.configure()
        viewController.modalPresentationStyle = .overFullScreen
        viewController.dataStore.subCategories = subCategories
        viewController.delegate = self.viewController
        self.viewController?.present(viewController, animated: true, completion: nil)
    }
}
