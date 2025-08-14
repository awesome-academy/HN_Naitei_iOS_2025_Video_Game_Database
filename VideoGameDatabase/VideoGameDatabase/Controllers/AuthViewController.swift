//
//  AuthViewController.swift
//  VideoGameDatabase
//
//  Created by macbook on 14/8/25.
//

import UIKit
import FirebaseAuth

final class AuthViewController: UIViewController {
    
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    
    @IBAction private func onSignInButtonPressed(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showAlert(title: "Input Error", message: "Please enter both email and password.")
            return
        }
        AuthService.shared.signIn(withEmail: email, password: password) { [weak self] error in
            guard let self = self else { return }
            
            if let error = error {
                self.showAlert(title: "Sign-In Failed", message: error.localizedDescription)
                return
            }
            self.toMain()
        }
    }
    
    @IBAction private func onSignUpButtonPressed(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showAlert(title: "Input Error", message: "Please enter both email and password.")
            return
        }
        
        AuthService.shared.signUp(withEmail: email, password: password) { [weak self] error in
            guard let self = self else { return }
            
            if let error = error {
                self.showAlert(title: "Sign-Up Failed", message: error.localizedDescription)
                return
            }
            self.toMain()
        }
    }
    
    // MARK: - Navigation
    
    private func toMain() {
        guard let window = view.window else { return }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(withIdentifier: "MainTabBarController")
        
        window.rootViewController = mainTabBarController
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
    }
}
