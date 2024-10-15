//
//  SceneDelegate.swift
//  ExpenseTracker
//
//  Created by Mac on 15/10/2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        let rootViewController = ExpensesViewController()
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
        window?.backgroundColor = .white
        func sceneDidDisconnect(_ scene: UIScene) {
        }
        
        func sceneDidBecomeActive(_ scene: UIScene) {
        }
        
        func sceneWillResignActive(_ scene: UIScene) {
        }
        
        func sceneWillEnterForeground(_ scene: UIScene) {
        }
        
        func sceneDidEnterBackground(_ scene: UIScene) {
        }
    }
    
}
