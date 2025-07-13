//
//  CurrencyFormatterTests.swift
//  GlobeSalesTests
//
//  Created by Иван Дроботов on 7/13/25.
//

import XCTest
@testable import GlobeSales // Замените на имя вашего модуля

final class CurrencyFormatterServiceTests: XCTestCase {

    // MARK: - Properties
    
    private var formatter: CurrencyFormatterProtocol!

    // MARK: - Lifecycle
    
    override func setUp() {
        super.setUp()
        formatter = CurrencyFormatter()
    }

    override func tearDown() {
        formatter = nil
        super.tearDown()
    }

    // MARK: - Tests

    func test_format_withUSD_shouldReturnCorrectString() {
        // Given
        let value: Double = 30.20
        let currencyCode = "USD"
        
        // When
        let formattedString = formatter.getCurrencyFormat(value: value, currencyCode: currencyCode)
        
        // Then
        XCTAssertTrue(formattedString.contains("$"), "Строка должна содержать символ доллара")
        XCTAssertTrue(formattedString.contains("30.20"), "Строка должна содержать число 30.20")
    }
    
    func test_format_withGBP_shouldReturnCorrectString() {
        // Given
        let value: Double = 23.25
        let currencyCode = "GBP"
        
        // When
        let formattedString = formatter.getCurrencyFormat(value: value, currencyCode: currencyCode)
        
        // Then
        XCTAssertTrue(formattedString.contains("£"), "Строка должна содержать символ фунта")
        XCTAssertTrue(formattedString.contains("23.25"), "Строка должна содержать число 23.25")
    }
    
    func test_format_withEUR_shouldReturnCorrectString() {
        // Given
        let value: Double = 150.50
        let currencyCode = "EUR"
        
        // When
        let formattedString = formatter.getCurrencyFormat(value: value, currencyCode: currencyCode)
        
        // Then
        XCTAssertTrue(formattedString.contains("€"), "Строка должна содержать символ евро")
        XCTAssertTrue(formattedString.contains("150.50"), "Строка должна содержать число 150.50")
    }

    func test_format_withZeroAmount_shouldFormatCorrectly() {
        // Given
        let value: Double = 0.0
        let currencyCode = "USD"
        
        // When
        let formattedString = formatter.getCurrencyFormat(value: value, currencyCode: currencyCode)
        
        // Then
        XCTAssertTrue(formattedString.contains("$"))
        XCTAssertTrue(formattedString.contains("0.00"), "Нулевое значение должно форматироваться как 0.00")
    }
    
    func test_format_withLargeAmount_shouldIncludeGroupSeparators() {
        // Given
        let value: Double = 1234567.89
        let currencyCode = "USD"
        
        // When
        let formattedString = formatter.getCurrencyFormat(value: value, currencyCode: currencyCode)
        
        // Then
        let groupSeparator = Locale.current.groupingSeparator ?? ","
        XCTAssertTrue(formattedString.contains(groupSeparator), "Большие числа должны содержать разделители групп")
        XCTAssertTrue(formattedString.contains("1") && formattedString.contains("234") && formattedString.contains("567.89"))
    }
    
    func test_format_withInvalidCurrencyCode_shouldReturnStringWithoutSymbol() {
        // Given
        let value: Double = 100.00
        let invalidCode = "XYZ"
        
        // When
        let formattedString = formatter.getCurrencyFormat(value: value, currencyCode: invalidCode)
        
        // Then
        XCTAssertTrue(formattedString.contains(invalidCode), "Строка должна содержать код валюты, если символ не найден")
        XCTAssertTrue(formattedString.contains("100.00"))
    }
}
