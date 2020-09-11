//
//  LoginViewController.swift
//  MyTracker
//
//  Created by Kirill Anisimov on 06.09.2020.
//  Copyright © 2020 Kirill Anisimov. All rights reserved.
//

import UIKit

final class LoginViewController: UIViewController {
    
    enum Constants {
        static let login = "admin"
        static let password = "123456"
    }
    
    @IBOutlet weak var loginView: UITextField!
    @IBOutlet weak var passwordView: UITextField!
    
    var onLogin: (() -> Void)?
    var onRecover: (() -> Void)?
    var onSignUp: (() -> Void)?
    
    
    @IBAction func login(_ sender: Any) {
        guard
            let login = loginView.text,
            let password = passwordView.text,
            login != "" && password != ""
            else {
                showAlert("Alert", "Login and password required")
                return
        }
        if DBManager.instance.checkUser(login: login, password: password) {
            UserDefaults.standard.set(true, forKey: "isLogin")
            onLogin?()
        } else {
            showAlert("Alert", "Incorrect login and/or password")
        }
    }

    @IBAction func recovery(_ sender: Any) {
        onRecover?()
    }
    
    @IBAction func signUp(_ sender: Any) {
        onSignUp?()
    }
    
//    @IBAction func showPass(_ sender: Any) {
//        passwordView.isSecureTextEntry.toggle()
//    }
}
