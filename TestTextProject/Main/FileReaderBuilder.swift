//
//  FileReaderBuilder.swift
//  TestTextProject
//
//  Created by Andrey on 04.03.2024.
//

import UIKit

enum Storyboards: String {
    case main = "FileReader"
}

enum FileReaderBuilder {
    static func build() -> FileReaderViewController {
        let viewController = UIStoryboard(
            name: Storyboards.main.rawValue,
            bundle: .main
        ).instantiateViewController(withIdentifier: "\(FileReaderViewController.self)") as! FileReaderViewController

        let presenter = FileReaderPresenter(
            view: viewController,
            wordsCounterService: WordsCountManager(
                textFileService: TextFileServiceImpl()
            )
        )
        viewController.configure(presenter: presenter)

        return viewController
    }
}
