//
//  FileReaderServiceTests.swift
//  GlobeSalesTests
//
//  Created by Иван Дроботов on 7/11/25.
//

import XCTest
@testable import GlobeSales

//MARK: - Independent Model for tests

struct TestRateModel: Codable, Equatable {
    let from: String
    let to: String
    let rate: String
}

final class FileReaderTests: XCTestCase {

    private var fileReader: FileReaderProtocol!
    private var testBundle: Bundle!

    // MARK: - Lifecycle
    
    override func setUp() {
        super.setUp()
        testBundle = Bundle(for: type(of: self))
        fileReader = FileReader(bundle: testBundle)
    }

    override func tearDown() {
        fileReader = nil
        testBundle = nil
        super.tearDown()
    }

    // MARK: - Test load()
    
    func test_load_whenValidFileProvided_thenReturnsCorrectData() {
        // Given
        let fileName = "valid_rates"
        let expectedRates = [TestRateModel(from: "USD", to: "GBP", rate: "0.77")]
        
        // When
        do {
            let loadedRates: [TestRateModel] = try fileReader.load(TestRateModel.self, from: fileName)
            
            // Then
            XCTAssertEqual(loadedRates.count, 1, "Должен быть загружен 1 элемент")
            XCTAssertEqual(loadedRates, expectedRates, "Загруженные данные не соответствуют ожидаемым")
            
        } catch {
            XCTFail("Функция load не должна была бросить ошибку для валидного файла. Ошибка: \(error)")
        }
    }

    func test_load_whenFileNotFound_thenThrowsFileNotFoundError() {
        // Given
        let nonExistentFileName = "i_do_not_exist"
        
        // When
        XCTAssertThrowsError(try fileReader.load(TestRateModel.self, from: nonExistentFileName)) { error in
            // Then
            guard let serviceError = error as? FileReaderErorr else {
                return XCTFail("Была брошена ошибка неожиданного типа: \(type(of: error))")
            }
            
            // Проверяем конкретный кейс ошибки
            guard case .fileNotFound(let fileName) = serviceError else {
                return XCTFail("Ожидалась ошибка .fileNotFound, но получена \(serviceError)")
            }
            
            XCTAssertEqual(fileName, nonExistentFileName)
        }
    }
    
    func test_load_whenInvalidFileFormat_thenThrowsDecodingFailedError() {
        // Given
        let invalidFileName = "invalid_rates"
        
        // When
        XCTAssertThrowsError(try fileReader.load(TestRateModel.self, from: invalidFileName)) { error in
            //Then
            guard let serviceError = error as? FileReaderErorr else {
                return XCTFail("Была брошена ошибка неожиданного типа: \(type(of: error))")
            }
        
            guard case .decodingFailed = serviceError else {
                return XCTFail("Ожидалась ошибка .decodingFailed, но получена \(serviceError)")
            }
        }
    }

    // MARK: - Tests loadSafely()

    func test_loadSafely_whenValidFileProvided_thenReturnsCorrectData() {
        // Given
        let fileName = "valid_rates"
        let expectedRates = [TestRateModel(from: "USD", to: "GBP", rate: "0.77")]
        
        // When
        let loadedRates: [TestRateModel] = fileReader.loadSafely(TestRateModel.self, from: fileName)
        
        // Then
        XCTAssertEqual(loadedRates, expectedRates)
    }
    
    func test_loadSafely_whenFileNotFound_thenReturnsEmptyArray() {
        // Given
        let nonExistentFileName = "i_do_not_exist"
        
        // When
        let loadedRates: [TestRateModel] = fileReader.loadSafely(TestRateModel.self, from: nonExistentFileName)
        
        // Then
        XCTAssertTrue(loadedRates.isEmpty, "Должен вернуться пустой массив, если файл не найден")
    }
    
    func test_loadSafely_whenInvalidFileFormat_thenReturnsEmptyArray() {
        // Given
        let invalidFileName = "invalid_rates"
        
        // When
        let loadedRates: [TestRateModel] = fileReader.loadSafely(TestRateModel.self, from: invalidFileName)
        
        // Then
        XCTAssertTrue(loadedRates.isEmpty, "Должен вернуться пустой массив, если файл поврежден")
    }
}
