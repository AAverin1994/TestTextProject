//
//  AppDelegate.swift
//  TestTextProject
//
//  Created by Andrey on 22.02.2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = UINavigationController(rootViewController: FileReaderBuilder.build())
        self.window?.makeKeyAndVisible()

        return true
    }
}

