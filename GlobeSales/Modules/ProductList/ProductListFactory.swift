//
//  ProductListFactory.swift
//  GlobeSales
//
//  Created by Иван Дроботов on 7/13/25.
//

import UIKit

final class ProductListFactory {
    private let dataManager: DataManagerProtocol
    
    init(dataManager: DataManagerProtocol) {
        self.dataManager = dataManager
    }
    
    func make() -> UIViewController {
        let detailFactory = TransactionDetailFactory(dataManager: dataManager)
        
        let router = ProductListRouter(transactionDetailFactory: detailFactory)
        let presenter = ProductListPresenter(router: router, dataManager: dataManager)
        let viewController = ProductListViewController(presenter: presenter)
        
        presenter.view = viewController
        router.viewController = viewController
        
        return viewController
    }
}
