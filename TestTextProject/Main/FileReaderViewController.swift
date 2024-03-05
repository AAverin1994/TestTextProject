//
//  ViewController.swift
//  TestTextProject
//
//  Created by Andrey on 22.02.2024.
//

import UIKit

final class FileReaderViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var placeholderLabel: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    private var cellIdentifier: String {
        "\(UITableViewCell.self)"
    }

    private var presenter: FileReaderInput!

    private var currentItems: [(String, Int)] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    // MARK: - Main

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.viewDidLoad()
    }

    func setupUI() {
        title = "Main Text Reader"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Reload", style: .done, target: self, action: #selector(didReload))
    }

    // MARK: - Configure

    func configure(presenter: FileReaderInput) {
        self.presenter = presenter
    }

    // MARK: - Actions

    @objc func didReload() {
        presenter.reload()
    }
}

// MARK: - FilerReaderView

extension FileReaderViewController: FileReaderView {
    func didChange(state: FileReaderState) {
        updateView(with: state)
    }

    func showLoader() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }

    func hideLoader() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }

    func updateView(with state: FileReaderState) {
        switch state {
        case .load:
            currentItems = []
            showLoader()
        case let .loaded(items):
            hideLoader()
            currentItems = items
        case let .error(error):
            hideLoader()
            showAlert(
                .withOneAction(
                    title: "Error",
                    description: error.localizedDescription,
                    action: { [weak self] in
                        self?.presenter.reload()
                    }
                )
            )
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension FileReaderViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)

        let index = indexPath.row
        let item = currentItems[index]
        cell.textLabel?.text = "\(index + 1). \(item.0) - \(item.1)"
        return cell
    }
}
