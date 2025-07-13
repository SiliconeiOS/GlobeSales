//
//  ProductListPresenter.swift
//  GlobeSales
//
//  Created by Иван Дроботов on 7/13/25.
//

import Foundation

protocol ProductListPresenterProtocol {
    func viewDidLoad()
    func didSelectProduct(at index: Int)
}

final class ProductListPresenter: ProductListPresenterProtocol {
    
    weak var view: ProductListViewProtocol?
    private let router: ProductListRouterProtocol
    private let dataManager: DataManagerProtocol
    
    private var groupedTransactions: [String: [TransactionModel]] = [:]
    private var sortedSKUs: [String] = []

    init(router: ProductListRouterProtocol, dataManager: DataManagerProtocol) {
        self.router = router
        self.dataManager = dataManager
    }

    func viewDidLoad() {
        processTransactions()
    }
    
    private func processTransactions() {
        groupedTransactions = Dictionary(grouping: dataManager.transactions, by: { $0.sku })
        sortedSKUs = groupedTransactions.keys.sorted()
        
        let productViewModels = sortedSKUs.map { sku -> ProductCellViewModel in
            let count = groupedTransactions[sku]?.count ?? 0
            return ProductCellViewModel(sku: sku, transactionCount: "\(count) transactions")
        }
        
        view?.display(viewModel: .init(products: productViewModels))
    }
    
    func didSelectProduct(at index: Int) {
        guard sortedSKUs.indices.contains(index) else { return }
        
        let selectedSKU = sortedSKUs[index]
        guard let transactionsForSKU = groupedTransactions[selectedSKU] else { return }
        
        router.navigateToDetail(for: selectedSKU, transactions: transactionsForSKU)
    }
}
