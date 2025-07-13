//
//  FileReaderService.swift
//  GlobeSales
//
//  Created by Иван Дроботов on 7/11/25.
//

import Foundation

protocol FileReaderProtocol {
    func load<T: Codable>(_ type: T.Type, from fileName: String) throws -> [T]
    func loadSafely<T: Codable>(_ type: T.Type, from fileName: String) -> [T]
}

public final class FileReader: FileReaderProtocol {
    
    private let bundle: Bundle
    
    init(bundle: Bundle = .main) {
        self.bundle = bundle
    }
    
    func load<T>(_ type: T.Type, from fileName: String) throws -> [T] where T : Codable {
        guard let url = bundle.url(forResource: fileName, withExtension: .plist) else {
            throw FileReaderErorr.fileNotFound(fileName)
        }
        
        do {
            let data = try Data(contentsOf: url)
            let docode = PropertyListDecoder()
            let items = try docode.decode([T].self, from: data)
            
            return items
        } catch let decodingError as DecodingError {
            throw FileReaderErorr.decodingFailed(decodingError)
        } catch {
            throw FileReaderErorr.invalidData(error)
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

enum FileReaderErorr: Error, LocalizedError {
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
