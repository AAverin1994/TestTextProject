//
//  TextFileService.swift
//  TestTextProject
//
//  Created by Andrey on 04.03.2024.
//

import UIKit

protocol TextFileService {
    func loadFilesFromDefaultPath(completion: @escaping (Result<[String], Error>) -> Void)
}

enum TextFileServiceError: Error {
    case fileDoesNotExist
    case nonSupportedFormat
    case couldNotOpenFile
}

enum TextFileSupportedFormat: String {
    case txt = ".txt"
}

final class TextFileServiceImpl: TextFileService {
    private let fileManager = FileManager.default
    private let supportedFilesFormat: [TextFileSupportedFormat] = [.txt]

    // MARK: - Internal

    func loadFilesFromDefaultPath(completion: @escaping (Result<[String], Error>) -> Void) {
        guard let documentURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first,
              let listFiles = try? fileManager.contentsOfDirectory(at: documentURL, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles])
        else {
            completion(.failure(TextFileServiceError.couldNotOpenFile))
            return
        }

        completion(.success(filterAndOpenTextFiles(listFiles)))
    }

    // MARK: - Private

    private func filterAndOpenTextFiles(_ paths: [URL]) -> [String] {
        let filteredPaths = paths.filter { path in
            let isSupported = supportedFilesFormat.reduce(false) {
                $0 || path.lastPathComponent.contains($1.rawValue)
            }

            return isSupported
        }

        return filteredPaths.compactMap { try? loadText(from: $0) }
    }

    private func loadText(from file: URL) throws -> String {
        let isSupported = supportedFilesFormat.reduce(false) {
            $0 || file.lastPathComponent.contains($1.rawValue)
        }

        guard isSupported else {
            throw TextFileServiceError.nonSupportedFormat
        }

        do {
            return try String(contentsOf: file)
        } catch {
            throw error
        }
    }
}
