//
//  TransactionDataModel.swift
//  GlobeSales
//
//  Created by Иван Дроботов on 7/11/25.
//

import Foundation

// MARK: - Transaction Data Layer Model

struct TransactionDataModel: Codable {
    let sku: String
    let currency: String
    let amount: String
}

// MARK: - Debug Extensions

extension TransactionDataModel: CustomStringConvertible {
    var description: String {
        return "TransactionDataModel(sku: \(sku), currency: \(currency), amount: \(amount))"
    }
} 
