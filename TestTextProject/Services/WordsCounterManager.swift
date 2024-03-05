//
//  WordsCounterManager.swift
//  TestTextProject
//
//  Created by Andrey on 05.03.2024.
//

import Foundation

protocol WordsCounterService {
    func calculate(with minWordlenght: Int, completion: @escaping (Result<[(String, Int)], Error>) -> Void)
}

final class WordsCountManager {
    private let textFileService: TextFileService
    private let buffer: AtomicBuffer<[String: Int]> = .init()
    private lazy var threadCompleater: CompleaterValue = .init(value: 0, completion: didCompleateCalculation)
    private let mostRepeatedWordsCount: Int = 10

    private var completion: ((Result<[(String, Int)], Error>) -> Void)?

    init(textFileService: TextFileService) {
        self.textFileService = textFileService
    }
}

// MARK: - WordsCounterService

extension WordsCountManager: WordsCounterService {
    func didCompleateCalculation() {
        var mergedValues: [String: Int] = [:]

        for dictionary in buffer.values {
            dictionary.keys.forEach {
                guard let currentValue = mergedValues[$0] else {
                    mergedValues[$0] = dictionary[$0]
                    return
                }

                mergedValues[$0] = max(currentValue, dictionary[$0] ?? currentValue)
            }
        }

        var newResult = mergedValues.map { ($0, $1) }.sorted(by: { $0.1 > $1.1 })

        if newResult.count > mostRepeatedWordsCount {
            newResult = Array(newResult[0..<mostRepeatedWordsCount])
        }

        if !Thread.isMainThread {
            RunLoop.main.perform { [weak self] in
                self?.completion?(.success(newResult))
            }
        } else {
            completion?(.success(newResult))
        }

        buffer.clear()
    }

    func calculate(with minWordlenght: Int, completion: @escaping (Result<[(String, Int)], Error>) -> Void) {
        textFileService.loadFilesFromDefaultPath { [weak self] result in
            switch result {
            case let .success(texts):
                self?.completion = completion

                self?.threadCompleater.value = texts.count
                texts.forEach { text in
                    Thread {
                        let wordsCalculator = RepeatedWordsCalculator()
                        let textResult = wordsCalculator.calculate(text: text, minWordLenght: minWordlenght)
                        self?.buffer.append(textResult)
                        self?.threadCompleater.value -= 1
                    }.start()
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
