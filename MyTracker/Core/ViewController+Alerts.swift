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
    
    func showAlertWithComletion(_ title: String, _ message: String, completion: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            completion()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func showMapAlert(_ title: String, _ message: String, completion: @escaping () -> Void) {
        let alert = UIAlertController (title: title,
                                       message: message,
                                       preferredStyle: .alert)
        alert.addAction (UIAlertAction(title: "Stop", style: .default, handler: { action in
            completion()
        }))
        alert.addAction (UIAlertAction(title: "Cancel", style: .default, handler: { action in
            print("Tracking continuing")
        }))
        present(alert, animated: true, completion: nil )
        
    }
}
