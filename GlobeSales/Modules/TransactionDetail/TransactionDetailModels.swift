//
//  TransactionDetailModels.swift
//  GlobeSales
//
//  Created by Иван Дроботов on 7/13/25.
//

import Foundation

import Foundation

struct TransactionDetailCellViewModel {
    let originalAmount: String
    let gbpAmount: String
}

struct TransactionDetailViewModel {
    let totalAmountInGBP: String
    let transactions: [TransactionDetailCellViewModel]
}
