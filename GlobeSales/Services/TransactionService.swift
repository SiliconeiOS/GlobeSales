import Foundation

// MARK: - Transaction Service Protocol

protocol TransactionServiceProtocol {
    func loadTransactions() throws -> [TransactionDataModel]
    func loadTransactionsSafely() -> [TransactionDataModel]
}

// MARK: - Transaction Service

class TransactionService: TransactionServiceProtocol {
    
    // MARK: - TransactionServiceProtocol
    func loadTransactions() throws -> [TransactionDataModel] {
        guard let path = Bundle.main.path(forResource: "transactions", ofType: "plist") else {
            throw TransactionServiceError.fileNotFound("transactions.plist")
        }
        
        guard let data = NSData(contentsOfFile: path) as Data? else {
            throw TransactionServiceError.invalidData
        }
        
        do {
            let decoder = PropertyListDecoder()
            let transactions = try decoder.decode([TransactionDataModel].self, from: data)
            guard !transactions.isEmpty else {
                throw TransactionServiceError.emptyData
            }
            return transactions
        } catch let decodingError {
            throw TransactionServiceError.decodingFailed(decodingError)
        }
    }
    
    func loadTransactionsSafely() -> [TransactionDataModel] {
        do {
            return try loadTransactions()
        } catch {
            print("⚠️ TransactionService: Failed to load transactions - \(error.localizedDescription)")
            return []
        }
    }
}

// MARK: - Transaction Service Errors

enum TransactionServiceError: Error, LocalizedError {
    case fileNotFound(String)
    case invalidData
    case emptyData
    case decodingFailed(Error)
    
    var errorDescription: String? {
        switch self {
        case .fileNotFound(let fileName):
            return "Transaction file not found: \(fileName)"
        case .invalidData:
            return "Invalid transaction data format"
        case .emptyData:
            return "Transaction file contains no data"
        case .decodingFailed(let error):
            return "Failed to decode transactions: \(error.localizedDescription)"
        }
    }
}

// MARK: - Singleton Access

extension TransactionService {
    static let shared = TransactionService()
} 
