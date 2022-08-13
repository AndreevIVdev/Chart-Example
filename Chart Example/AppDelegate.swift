//
//  AppDelegate.swift
//  Chart Example
//
//  Created by Илья Андреев on 13.08.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        UITabBar.appearance().tintColor = .systemGreen
        window?.overrideUserInterfaceStyle = .dark
        window?.rootViewController = DetailViewController(
            viewModel: .init(ticker: "AMZN",
                             dataSource: DataSource()
                            )
        )
        window?.makeKeyAndVisible()
        return true
    }
}

