//
//  HomeSceneRouter.swift
//  kulud
//
//  Created by Hussam Elsadany on 10/03/2021.
//  Copyright (c) 2021 Qmobile-IT. All rights reserved.
//

protocol HomeSceneRoutingLogic: AnyObject {
    
    typealias Controller = HomeSceneDisplayView & KuludHomeViewController
    
    func routeToCategory(_ category: CategoryModel)
    func routeToProductDetails(_ product: ProductModel)
    func routeToCart()
    func routeToWishList()
    func routeToOrders()
}

class HomeSceneRouter {

    // MARK: Stored Properties
    var viewController: Controller?

    // MARK: Initializers
    required init(controller: Controller?) {
        self.viewController = controller
    }
}

extension HomeSceneRouter: HomeSceneRoutingLogic {

    func routeToCategory(_ category: CategoryModel) {
        let viewController = CategoriesSceneConfigurator.configure()
        viewController.dataStore.selectedCategory = category
        self.viewController?.navigationController?.pushViewController(viewController, animated: true)
    }
    
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
}
