//
//  MockFileReader.swift
//  GlobeSalesTests
//
//  Created by Иван Дроботов on 7/13/25.
//

@testable import GlobeSales

final class MockFileReader: FileReaderProtocol {
    var rateDataModelsToReturn: [RateDataModel] = []
    var transactionDataModelsToReturn: [TransactionDataModel] = []
    
    func load<T>(_ type: T.Type, from fileName: String) throws -> [T] where T : Decodable, T : Encodable { [] }
    
    func loadSafely<T>(_ type: T.Type, from fileName: String) -> [T] where T : Decodable, T : Encodable {
        if type is RateDataModel.Type {
            return rateDataModelsToReturn as! [T]
        }
        if type is TransactionDataModel.Type {
            return transactionDataModelsToReturn as! [T]
        }
        return []
    }
}
