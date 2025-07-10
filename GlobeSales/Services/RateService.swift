import Foundation

// MARK: - Rate Service Protocol

protocol RateServiceProtocol {
    func loadRates() throws -> [RateDataModel]
    func loadRatesSafely() -> [RateDataModel]
}

// MARK: - Rate Service Implementation

class RateService: RateServiceProtocol {
    
    // MARK: - RateServiceProtocol
    
    func loadRates() throws -> [RateDataModel] {
        guard let path = Bundle.main.path(forResource: "rates", ofType: "plist") else {
            throw RateServiceError.fileNotFound("rates.plist")
        }
        
        guard let data = NSData(contentsOfFile: path) as Data? else {
            throw RateServiceError.invalidData
        }
        
        do {
            let decoder = PropertyListDecoder()
            let rates = try decoder.decode([RateDataModel].self, from: data)
            
            guard !rates.isEmpty else {
                throw RateServiceError.emptyData
            }
            
            return rates
        } catch let decodingError {
            throw RateServiceError.decodingFailed(decodingError)
        }
    }
    
    func loadRatesSafely() -> [RateDataModel] {
        do {
            return try loadRates()
        } catch {
            print("⚠️ RateService: Failed to load rates - \(error.localizedDescription)")
            return []
        }
    }
}

// MARK: - Rate Service Errors

enum RateServiceError: Error, LocalizedError {
    case fileNotFound(String)
    case invalidData
    case emptyData
    case decodingFailed(Error)
    
    var errorDescription: String? {
        switch self {
        case .fileNotFound(let fileName):
            return "Rate file not found: \(fileName)"
        case .invalidData:
            return "Invalid rate data format"
        case .emptyData:
            return "Rate file contains no data"
        case .decodingFailed(let error):
            return "Failed to decode rates: \(error.localizedDescription)"
        }
    }
}
