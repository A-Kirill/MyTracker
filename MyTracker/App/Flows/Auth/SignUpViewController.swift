//
//  SignUpViewController.swift
//  MyTracker
//
//  Created by Kirill Anisimov on 07.09.2020.
//  Copyright © 2020 Kirill Anisimov. All rights reserved.
//

import UIKit

final class SignUpViewController: UIViewController {

    @IBOutlet weak var loginView: UITextField!
    @IBOutlet weak var passwordView: UITextField!
    
    @IBAction func signUpPressed(_ sender: Any) {
        
        guard
            let login = loginView.text,
            let password = passwordView.text,
            login != "" && password != ""
            else {
                showAlert("Alert", "Login and password required")
                return
        }
        if DBManager.instance.registerUser(login: login, password: password) {
            showAlertWithComletion("Success", "Try login with new credentials") {
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            showAlert("Error", "Error occured while user register")
        }
        UserDefaults.standard.set(true, forKey: "isLogin")
    }
    
}
