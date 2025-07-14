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
    private let transactionDetailFactory: TransactionDetailFactory
    
    init(transactionDetailFactory: TransactionDetailFactory) {
        self.transactionDetailFactory = transactionDetailFactory
    }
    
    func navigateToDetail(for sku: String, transactions: [TransactionModel]) {
        let context = TransactionDetailFactory.Context(sku: sku, transactions: transactions)
        let detailVC = transactionDetailFactory.make(context: context)
        viewController?.navigationController?.pushViewController(detailVC, animated: true)
    }
}
