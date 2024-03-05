//
//  ViewController+Alert.swift
//  TestTextProject
//
//  Created by Andrey on 04.03.2024.
//

import UIKit

struct AlertData {
    struct Button {
        let title: String
        let action: (() -> Void)?
    }

    let title: String
    let description: String?
    let buttons: [Button]

    static func withOneAction(title: String, description: String? = nil, action: (() -> Void)? = nil) -> AlertData {
        AlertData(
            title: title,
            description: description,
            buttons: [Button(title: "Ok", action: action)]
        )
    }

    static func withTwoActions(title: String, description: String? = nil, closeAction: (() -> Void)? = nil, mainAction: (() -> Void)? = nil) -> AlertData {
        AlertData(
            title: title,
            description: description,
            buttons: [
                Button(title: "Ok", action: mainAction),
                Button(title: "Cancel", action: closeAction),
            ]
        )
    }
}

extension UIViewController {
    func showAlert(_ data: AlertData) {
        guard let viewController = presentedViewController else { return }
        
        let alertViewController = UIAlertController(
            title: data.title, message:
                data.description,
            preferredStyle: .alert
        )

        data.buttons.forEach { button in
            let action = UIAlertAction(
                title: button.title,
                style: .default,
                handler: { _ in
                    button.action?()
                    alertViewController.dismiss(animated: true)
                }
            )

            alertViewController.addAction(action)
        }

        viewController.present(alertViewController, animated: true)
    }
}
