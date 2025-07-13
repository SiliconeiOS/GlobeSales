//
//  TransactionDetailFactory.swift
//  GlobeSales
//
//  Created by Иван Дроботов on 7/13/25.
//

import UIKit

final class TransactionDetailFactory {
    
    struct Context {
        let sku: String
        let transactions: [TransactionModel]
    }
    
    private let dataManager: DataManagerProtocol
    
    init(dataManager: DataManagerProtocol) {
        self.dataManager = dataManager
    }

    func make(context: Context) -> UIViewController {
        let presenter = TransactionDetailPresenter(
            sku: context.sku,
            transactions: context.transactions,
            dataManager: dataManager
        )
        let viewController = TransactionDetailViewController(presenter: presenter)
        presenter.view = viewController
        
        return viewController
    }
}
