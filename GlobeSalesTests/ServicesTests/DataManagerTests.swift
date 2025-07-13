//
//  DataManagerTests.swift
//  GlobeSalesTests
//
//  Created by Иван Дроботов on 7/13/25.
//

import XCTest
@testable import GlobeSales

final class DataManagerTests: XCTestCase {

    func test_init_withPartiallyInvalidData_shouldFilterOutInvalidModels() {
        // Given
        let mockFileReader = MockFileReader()
        
        mockFileReader.rateDataModelsToReturn = [
            RateDataModel(from: "USD", to: "EUR", rate: "1.1"), // valid
            RateDataModel(from: "JPY", to: "CNY", rate: "abc")  // invalid
        ]
        mockFileReader.transactionDataModelsToReturn = [
            TransactionDataModel(sku: "SKU123", currency: "USD", amount: "10.0"), // valid
            TransactionDataModel(sku: "", currency: "EUR", amount: "20.0")        // invalid
        ]
        
        // When
        let dataManager = DataManager(fileReader: mockFileReader)

        // Then
        XCTAssertEqual(dataManager.transactions.count, 1, "Должна остаться только одна валидная транзакция")
        XCTAssertEqual(dataManager.transactions.first?.sku, "SKU123")
        
        let conversionResult = dataManager.currencyConverter.convert(amount: 100, from: "USD", to: "EUR")
        XCTAssertNotNil(conversionResult, "Валидная конвертация должна работать")
        
        let nonExistentConversion = dataManager.currencyConverter.convert(amount: 100, from: "JPY", to: "CNY")
        XCTAssertNil(nonExistentConversion, "Невалидный курс не должен был попасть в конвертер")
    }
}
