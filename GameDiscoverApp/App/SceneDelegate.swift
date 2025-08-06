//
//  SceneDelegate.swift
//  GameDiscoverApp
//
//  Created by macbook on 31/7/25.
//

import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        let tabBarController = UITabBarController()
        
        let homeVC = HomeViewController()
        homeVC.title = "Home"
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 0)
        
        let discoverVC = DiscoverViewController()
        discoverVC.title = "Discover"
        discoverVC.tabBarItem = UITabBarItem(title: "Discover", image: UIImage(systemName: "magnifyingglass"), tag: 1)
        
        let favoritesVC = FavoritesViewController()
        favoritesVC.title = "Favorites"
        favoritesVC.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "heart.fill"), tag: 2)
        
        let homeNav = UINavigationController(rootViewController: homeVC)
        let discoverNav = UINavigationController(rootViewController: discoverVC)
        let favoritesNav = UINavigationController(rootViewController: favoritesVC)
        
        tabBarController.viewControllers = [homeNav, discoverNav, favoritesNav]
        
        if Auth.auth().currentUser != nil {
               window.rootViewController = tabBarController
           } else {
               let authVC = AuthViewController()
               let authNav = UINavigationController(rootViewController: authVC)
               window.rootViewController = authNav
           }
           
           window.makeKeyAndVisible()
           self.window = window
            window.makeKeyAndVisible()
        self.window = window
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

