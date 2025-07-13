//
//  ProductListRouter.swift
//  GlobeSales
//
//  Created by Иван Дроботов on 7/13/25.
//

import UIKit

protocol ProductListRouterProtocol {
    func navigateToDetail(for sku: String, transactions: [TransactionModel])
}

final class ProductListRouter: ProductListRouterProtocol {
    weak var viewController: UIViewController?
    private let dataManager: DataManagerProtocol
    
    init(dataManager: DataManagerProtocol) {
        self.dataManager = dataManager
    }
    
    func navigateToDetail(for sku: String, transactions: [TransactionModel]) {
    }
}
