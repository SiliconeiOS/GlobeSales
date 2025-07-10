import Foundation

// MARK: - Rate Domain Model

/// Domain модель для работы с курсами валют в бизнес-логике
struct RateModel {
    let from: String
    let to: String
    let rate: Double
}

// MARK: - Mapping from Data Layer

extension RateModel {
    init(from dataModel: RateDataModel) throws {
        guard !dataModel.from.isEmpty else {
            throw RateMappingError.invalidFromCurrency
        }
        guard !dataModel.to.isEmpty else {
            throw RateMappingError.invalidToCurrency
        }
        guard let rate = Double(dataModel.rate),
              rate > 0
        else {
            throw RateMappingError.invalidRate(dataModel.rate)
        }
        
        self.from = dataModel.from
        self.to = dataModel.to
        self.rate = rate
    }
}


// MARK: - Mapping Errors

enum RateMappingError: Error, LocalizedError {
    case invalidRate(String)
    case negativeRate(Double)
    case invalidFromCurrency
    case invalidToCurrency
    
    var errorDescription: String? {
        switch self {
        case .invalidRate(let rate):
            return "Invalid rate format: '\(rate)'"
        case .negativeRate(let rate):
            return "Rate must be positive, got: \(rate)"
        case .invalidFromCurrency:
            return "Source currency cannot be empty"
        case .invalidToCurrency:
            return "Target currency cannot be empty"
        }
    }
}

// MARK: - Debug Extensions

extension RateModel: CustomStringConvertible {
    var description: String {
        return "Rate(from: \(from), to: \(to), rate: \(rate))"
    }
} 
