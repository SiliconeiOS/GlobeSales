//
//  CurrencyConverter.swift
//  GlobeSalesTests
//
//  Created by Иван Дроботов on 7/13/25.
//

import XCTest
@testable import GlobeSales

final class CurrencyConverterTests: XCTestCase {

    // MARK: - Properties
    
    private var converter: CurrencyConverterProtocol!
    
    // MARK: - Tests

    func test_convert_withDirectRate_shouldReturnCorrectValue() {
        // Given
        let rates = [RateModel(from: "USD", to: "CAD", rate: 1.3)]
        converter = CurrencyConverter(rates: rates)
        
        // When
        let result = converter.convert(amount: 100, from: "USD", to: "CAD")
        
        // Then
        XCTAssertNotNil(result)
        XCTAssertEqual(result!, 130.0, accuracy: 0.001)
    }

    func test_convert_withInverseRate_shouldReturnCorrectValue() {
        // Given
        let rates = [RateModel(from: "USD", to: "CAD", rate: 1.3)]
        converter = CurrencyConverter(rates: rates)
        
        // When
        let result = converter.convert(amount: 130, from: "CAD", to: "USD")
        
        // Then
        XCTAssertNotNil(result)
        XCTAssertEqual(result!, 100.0, accuracy: 0.001)
    }

    func test_convert_withChainedRate_shouldReturnCorrectValue() {
        // Given
        let rates = [
            RateModel(from: "USD", to: "CAD", rate: 1.3),
            RateModel(from: "CAD", to: "GBP", rate: 0.5)
        ]
        converter = CurrencyConverter(rates: rates)
        
        // When
        let result = converter.convert(amount: 100, from: "USD", to: "GBP")
        
        // Then: USD -> CAD -> GBP (100 * 1.3 * 0.5 = 65)
        XCTAssertNotNil(result)
        XCTAssertEqual(result!, 65.0, accuracy: 0.001)
    }
    
    func test_convert_withInverseChainedRate_shouldReturnCorrectValue() {
        // Given
        let rates = [
            RateModel(from: "USD", to: "CAD", rate: 1.3),
            RateModel(from: "CAD", to: "GBP", rate: 0.5)
        ]
        converter = CurrencyConverter(rates: rates)
        
        // When
        let result = converter.convert(amount: 65, from: "GBP", to: "USD")
        
        // Then: GBP -> CAD -> USD (65 * (1/0.5) * (1/1.3) = 100)
        XCTAssertNotNil(result)
        XCTAssertEqual(result!, 100.0, accuracy: 0.001)
    }

    func test_convert_withSameCurrency_shouldReturnSameAmount() {
        // Given
        let rates = [RateModel(from: "USD", to: "CAD", rate: 1.3)]
        converter = CurrencyConverter(rates: rates)
        
        // When
        let result = converter.convert(amount: 100, from: "USD", to: "USD")
        
        // Then
        XCTAssertNotNil(result)
        XCTAssertEqual(result, 100.0)
    }

    func test_convert_withEmptyRatesList_shouldReturnNilForAnyConversion() {
        // Given
        converter = CurrencyConverter(rates: [])
        
        // When
        let result = converter.convert(amount: 100, from: "USD", to: "CAD")
        
        // Then
        XCTAssertNil(result, "Конвертация с пустым списком курсов должна возвращать nil")
    }

    func test_convert_withUnconnectedCurrencies_shouldReturnNil() {
        // Given
        let rates = [
            RateModel(from: "USD", to: "CAD", rate: 1.3),
            RateModel(from: "EUR", to: "JPY", rate: 160.0)
        ]
        converter = CurrencyConverter(rates: rates)
        
        // When
        let result = converter.convert(amount: 100, from: "USD", to: "EUR")
        
        // Then
        XCTAssertNil(result, "Конвертация между несвязанными валютными графами должна вернуть nil")
    }
    
    func test_convert_withNonExistentStartCurrency_shouldReturnNil() {
        // Given
        let rates = [RateModel(from: "USD", to: "CAD", rate: 1.3)]
        converter = CurrencyConverter(rates: rates)
        
        // When
        let result = converter.convert(amount: 100, from: "XYZ", to: "USD")
        
        // Then
        XCTAssertNil(result, "Конвертация из несуществующей валюты должна вернуть nil")
    }
    
    func test_convert_withNonExistentTargetCurrency_shouldReturnNil() {
        // Given
        let rates = [RateModel(from: "USD", to: "CAD", rate: 1.3)]
        converter = CurrencyConverter(rates: rates)
        
        // When
        let result = converter.convert(amount: 100, from: "USD", to: "XYZ")
        
        // Then
        XCTAssertNil(result, "Конвертация в несуществующую валюту должна вернуть nil")
    }
    
    // MARK: - 3. Complex Graph Scenarios

    func test_convert_withMultiplePaths_shouldChooseShortestPath() {
        // Given
        // Короткий путь: USD -> JPY (длина 1)
        // Длинный путь: USD -> CAD -> GBP -> JPY (длина 3)
        let rates = [
            RateModel(from: "USD", to: "JPY", rate: 150.0), // Короткий путь
            RateModel(from: "USD", to: "CAD", rate: 1.3),   // Начало длинного пути
            RateModel(from: "CAD", to: "GBP", rate: 0.5),
            RateModel(from: "GBP", to: "JPY", rate: 220.0)
        ]
        converter = CurrencyConverter(rates: rates)
        
        // When
        let result = converter.convert(amount: 10, from: "USD", to: "JPY")
        
        // Then
        // Алгоритм BFS должен найти путь длиной 1 и остановиться.
        // Ожидаемый результат: 10 * 150.0 = 1500.0
        XCTAssertNotNil(result)
        XCTAssertEqual(result!, 1500.0, accuracy: 0.001, "BFS должен выбирать кратчайший по числу шагов путь")
    }

    func test_convert_withCyclicGraph_shouldNotEnterInfiniteLoop() {
        // Given
        // Цикл: USD -> CAD -> GBP -> USD
        // Выход из цикла к цели: CAD -> JPY
        let rates = [
            RateModel(from: "USD", to: "CAD", rate: 1.3),
            RateModel(from: "CAD", to: "GBP", rate: 0.5),
            RateModel(from: "GBP", to: "USD", rate: 1.5), // Замыкание цикла
            RateModel(from: "CAD", to: "JPY", rate: 100.0) // Правильный путь
        ]
        converter = CurrencyConverter(rates: rates)
        
        // When
        // Если `visited` сет не работает, этот тест зависнет или упадет по таймауту.
        let result = converter.convert(amount: 10, from: "USD", to: "JPY")
        
        // Then
        // Ожидаемый путь: USD -> CAD -> JPY
        // Результат: 10 * 1.3 * 100.0 = 1300.0
        XCTAssertNotNil(result)
        XCTAssertEqual(result!, 1300.0, accuracy: 0.001, "Конвертер не должен зацикливаться")
    }
    
    
    func test_convert_withInvalidZeroRate_shouldBeIgnored() {
        // Given
        // Мы предоставляем один валидный курс и один невалидный (с нулевым значением).
        let rates = [
            RateModel(from: "USD", to: "CAD", rate: 0.0), // Невалидный
            RateModel(from: "EUR", to: "GBP", rate: 0.85) // Валидный
        ]
        converter = CurrencyConverter(rates: rates)
        
        // When
        let invalidPathResult = converter.convert(amount: 100, from: "USD", to: "CAD")
        let validPathResult = converter.convert(amount: 100, from: "EUR", to: "GBP")
        
        // Then
        XCTAssertNil(invalidPathResult, "Запись с нулевым курсом должна полностью игнорироваться, поэтому путь не должен быть найден")
        XCTAssertNotNil(validPathResult)
        XCTAssertEqual(validPathResult!, 85.0, accuracy: 0.001, "Валидные курсы должны обрабатываться корректно")
    }
}
