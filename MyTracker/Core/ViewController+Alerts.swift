//
//  ViewController+Alerts.swift
//  MyTracker
//
//  Created by Kirill Anisimov on 08.09.2020.
//  Copyright © 2020 Kirill Anisimov. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}
