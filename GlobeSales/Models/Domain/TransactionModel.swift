//
//  RateModel.swift
//  GlobeSales
//
//  Created by Иван Дроботов on 7/11/25.
//

import Foundation

// MARK: - Transaction Domain Model

struct TransactionModel {
    let sku: String
    let currency: String
    let amount: Double
}

// MARK: - Mapping from Data Layer

extension TransactionModel {
    init(from dataModel: TransactionDataModel) throws {
        guard !dataModel.sku.isEmpty else {
            throw TransactionMappingError.invalidSKU
        }
        
        guard !dataModel.currency.isEmpty else {
            throw TransactionMappingError.invalidCurrency
        }
        
        guard let amount = Double(dataModel.amount), amount > 0 else {
            throw TransactionMappingError.invalidAmount(dataModel.amount)
        }
        
        self.sku = dataModel.sku
        self.currency = dataModel.currency
        self.amount = amount
    }
}

// MARK: - Mapping Errors

enum TransactionMappingError: Error, LocalizedError {
    case invalidAmount(String)
    case invalidSKU
    case invalidCurrency
    
    var errorDescription: String? {
        switch self {
        case .invalidAmount(let amount):
            return "Invalid amount format: '\(amount)'"
        case .invalidSKU:
            return "SKU cannot be empty"
        case .invalidCurrency:
            return "Currency cannot be empty"
        }
    }
}

// MARK: - Debug Extensions

extension TransactionModel: CustomStringConvertible {
    var description: String {
        return "Transaction(sku: \(sku), currency: \(currency), amount: \(amount))"
    }
} 
