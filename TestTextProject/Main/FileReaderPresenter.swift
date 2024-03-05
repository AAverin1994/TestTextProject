//
//  FileReaderPresenter.swift
//  TestTextProject
//
//  Created by Andrey on 04.03.2024.
//

import Foundation

enum FileReaderState {
    case load
    case loaded(items: [(String, Int)])
    case error(error: Error)
}

protocol FileReaderView: AnyObject {
    func didChange(state: FileReaderState)
}

protocol FileReaderInput: AnyObject {
    func viewDidLoad()
    func reload()
}

final class FileReaderPresenter {
    private weak var view: FileReaderView?
    private let wordsCounterService: WordsCounterService
    private let wordsLength: Int = 5

    private(set) var currentState: FileReaderState = .load {
        didSet {
            view?.didChange(state: currentState)
        }
    }

    init(view: FileReaderView, wordsCounterService: WordsCounterService) {
        self.view = view
        self.wordsCounterService = wordsCounterService
    }
}

// MARK: - FileReaderInput

extension FileReaderPresenter: FileReaderInput {
    func viewDidLoad() {
        shouldCalculcateWords()
    }

    func reload() {
        shouldCalculcateWords()
    }

    func shouldCalculcateWords() {
        currentState = .load

        wordsCounterService.calculate(with: wordsLength) { [weak self] result in
            switch result {
            case .success(let items):
                self?.currentState = .loaded(items: items)
            case .failure(let error):
                self?.currentState = .error(error: error)
            }
        }
    }
}
