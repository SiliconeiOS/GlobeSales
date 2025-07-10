import Foundation

// MARK: - Rate Data Layer Model

struct RateDataModel: Codable {
    let from: String
    let to: String
    let rate: String
}

// MARK: - Debug Extensions

extension RateDataModel: CustomStringConvertible {
    var description: String {
        return "RateDataModel(from: \(from), to: \(to), rate: \(rate))"
    }
} 
