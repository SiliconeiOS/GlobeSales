//
//  TransactionDetailPresenter.swift
//  GlobeSales
//
//  Created by Иван Дроботов on 7/13/25.
//

import Foundation

protocol TransactionDetailPresenterProtocol {
    func viewDidLoad()
}

final class TransactionDetailPresenter: TransactionDetailPresenterProtocol {
    
    private struct Constants {
        static let targetCurrency = "GBP"
    }
    
    weak var view: TransactionDetailViewProtocol?
    
    private let transactions: [TransactionModel]
    private let sku: String
    private let converter: CurrencyConverterProtocol
    private let formatter: CurrencyFormatterProtocol
    
    init(sku: String,
         transactions: [TransactionModel],
         dataManager: DataManagerProtocol,
         formatter: CurrencyFormatterProtocol = CurrencyFormatter()) {
        self.sku = sku
        self.transactions = transactions
        self.converter = dataManager.currencyConverter
        self.formatter = formatter
    }
    
    func viewDidLoad() {
        view?.setTitle("Transactions for \(sku)")
        processTransactions()
    }
    
    private func processTransactions() {
        var totalInGBP: Double = 0.0
        
        let cellViewModels = transactions.map { transaction -> TransactionDetailCellViewModel in
            let originalAmountString = formatter.getCurrencyFormat(value: transaction.amount, currencyCode: transaction.currency)
            
            var gbpAmountString = "N/A"
            if let convertedAmount = converter.convert(amount: transaction.amount, from: transaction.currency, to: Constants.targetCurrency) {
                totalInGBP += convertedAmount
                gbpAmountString = formatter.getCurrencyFormat(value: convertedAmount, currencyCode: Constants.targetCurrency)
            }
            
            return TransactionDetailCellViewModel(originalAmount: originalAmountString, gbpAmount: gbpAmountString)
        }
        
        let totalString = "Total: \(formatter.getCurrencyFormat(value: totalInGBP, currencyCode: Constants.targetCurrency))"
        let viewModel = TransactionDetailViewModel(totalAmountInGBP: totalString, transactions: cellViewModels)
        
        view?.display(viewModel: viewModel)
    }
}
