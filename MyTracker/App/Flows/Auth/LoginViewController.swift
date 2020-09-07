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
    
    
    @IBAction func login(_ sender: Any) {
        guard
            let login = loginView.text,
            let password = passwordView.text,
            login == Constants.login && password == Constants.password
        else {
            return
        }
        UserDefaults.standard.set(true, forKey: "isLogin")
        onLogin?()
    }

    @IBAction func recovery(_ sender: Any) {
        onRecover?()
    }
}
