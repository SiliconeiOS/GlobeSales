//
//  FileReaderService.swift
//  GlobeSales
//
//  Created by Иван Дроботов on 7/11/25.
//

import Foundation

protocol FileReaderServiceProtocol {
    func load<T: Codable>(_ type: T.Type, from fileName: String) throws -> [T]
    func loadSafely<T: Codable>(_ type: T.Type, from fileName: String) -> [T]
}

final class FileReaderService: FileReaderServiceProtocol {
    func load<T>(_ type: T.Type, from fileName: String) throws -> [T] where T : Codable {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: .plist) else {
            throw FileReaderServiceErorr.fileNotFound(fileName)
        }
        
        do {
            let data = try Data(contentsOf: url)
            let docode = PropertyListDecoder()
            let items = try docode.decode([T].self, from: data)
            
            return items
        } catch let decodingError as DecodingError {
            throw FileReaderServiceErorr.decodingFailed(decodingError)
        } catch {
            throw FileReaderServiceErorr.invalidData(error)
        }
    }
    
    func loadSafely<T>(_ type: T.Type, from fileName: String) -> [T] where T : Decodable, T : Encodable {
        do {
            return try load(type, from: fileName)
        } catch {
            print("⚠️ PlistService: Failed to load \(fileName).plist - \(error.localizedDescription)")
            return []
        }
    }
}

enum FileReaderServiceErorr: Error, LocalizedError {
    case fileNotFound(String)
    case decodingFailed(Error)
    case invalidData(Error)
    
    var errorDescription: String? {
        switch self {
        case .fileNotFound(let fileName):
            return "File not found \(fileName).plist"
        case .decodingFailed(let error):
            return "Failed to decode file data: \(error.localizedDescription)"
        case .invalidData(let error):
            return "File contains invalid data format: \(error.localizedDescription)"
        }
    }
}

private extension String {
    static var plist: String { "plist" }
}
