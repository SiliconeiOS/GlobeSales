//
//  NumberFormatterService.swift
//  GlobeSales
//
//  Created by Иван Дроботов on 7/13/25.
//

import Foundation

protocol CurrencyFormatterProtocol {
    func getCurrencyFormat(value: Double, currencyCode: String) -> String
}

final class CurrencyFormatter: CurrencyFormatterProtocol {
    
    private let numberFormatter: NumberFormatter

    init() {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        self.numberFormatter = formatter
    }
    
    func getCurrencyFormat(value: Double, currencyCode: String) -> String {
        numberFormatter.currencyCode = currencyCode
        let number = NSNumber(value: value)
        return numberFormatter.string(from: number) ?? ""
    }
}
