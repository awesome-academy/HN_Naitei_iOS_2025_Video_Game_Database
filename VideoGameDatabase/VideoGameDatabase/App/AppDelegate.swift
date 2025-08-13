//
//  AppDelegate.swift
//  VideoGameDatabase
//
//  Created by macbook on 6/8/25.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        configFirebase()
        setupAppearance()
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    private func configFirebase() {
        FirebaseApp.configure()
    }
    
    private func setupAppearance() {
        
        // --- TAB BAR ---
        
        let tabBarAppearance = UITabBarAppearance()
        
        tabBarAppearance.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
        
        // selected item
        let selectedColor = UIColor(red: 1.0, green: 0.76, blue: 0.3, alpha: 1.0)
        let selectedItemAppearance = UITabBarItemAppearance()
        selectedItemAppearance.selected.iconColor = selectedColor
        selectedItemAppearance.selected.titleTextAttributes = [.foregroundColor: selectedColor]
        
        //unselected item
        let unselectedColor = UIColor.systemGray
        let normalItemAppearance = UITabBarItemAppearance()
        normalItemAppearance.normal.iconColor = unselectedColor
        normalItemAppearance.normal.titleTextAttributes = [.foregroundColor: unselectedColor]
        
        tabBarAppearance.stackedLayoutAppearance = selectedItemAppearance
        tabBarAppearance.stackedLayoutAppearance = normalItemAppearance
        
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        
        // --- NAVIGATION BAR ---
        
        let navBarAppearance = UINavigationBarAppearance()
        
        navBarAppearance.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
        
        navBarAppearance.shadowColor = .clear
        
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        UINavigationBar.appearance().tintColor = .white
    }
}


