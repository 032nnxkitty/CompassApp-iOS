//
//  SceneDelegate.swift
//  CompassApp
//
//  Created by Arseniy Zolotarev on 05.05.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // MARK: Create Compass Module
        let compassView = CompassViewController()
        let compassPresenter = CompassPresenterImp(view: compassView)
        compassView.presenter = compassPresenter
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = compassView
        window?.makeKeyAndVisible()
    }
}

