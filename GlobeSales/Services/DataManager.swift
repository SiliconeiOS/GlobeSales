//
//  DataManager.swift
//  GlobeSales
//
//  Created by Иван Дроботов on 7/13/25.
//

import Foundation

protocol DataManagerProtocol {
    var transactions: [TransactionModel] { get }
    var currencyConverter: CurrencyConverterProtocol { get }
}

final class DataManager: DataManagerProtocol {
    
    let transactions: [TransactionModel]
    let currencyConverter: CurrencyConverterProtocol
    
    init(fileReader: FileReaderProtocol = FileReader()) {
        
        let rateDataModels = fileReader.loadSafely(RateDataModel.self, from: "rates")
        let rates = rateDataModels.compactMap { dataModel -> RateModel? in
            do {
                return try RateModel(from: dataModel)
            } catch {
                print("⚠️ Could not map RateDataModel: \(dataModel). Error: \(error.localizedDescription)")
                return nil
            }
        }
        self.currencyConverter = CurrencyConverter(rates: rates)
        
        let transactionDataModels = fileReader.loadSafely(TransactionDataModel.self, from: "transactions")
        self.transactions = transactionDataModels.compactMap { dataModel -> TransactionModel? in
            do {
                return try TransactionModel(from: dataModel)
            } catch {
                print("⚠️ Could not map TransactionDataModel: \(dataModel). Error: \(error.localizedDescription)")
                return nil
            }
        }
        
        print("✅ DataManager initialized. Loaded \(self.transactions.count) transactions and \(rates.count) rates.")
    }
}
