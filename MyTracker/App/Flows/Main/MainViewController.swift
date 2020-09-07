//
//  MainViewController.swift
//  MyTracker
//
//  Created by Kirill Anisimov on 06.09.2020.
//  Copyright © 2020 Kirill Anisimov. All rights reserved.
//

import UIKit

final class MainViewController: UIViewController {
    
    var onMap: ((String) -> Void)?
    var onLogout: (() -> Void)?
    
    @IBAction func showMap(_ sender: Any) {
        onMap?("map")
    }
    
    @IBAction func logout(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "isLogin")
        onLogout?()
    }

}
