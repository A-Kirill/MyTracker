//
//  SelfyViewController.swift
//  MyTracker
//
//  Created by Kirill Anisimov on 25.09.2020.
//  Copyright © 2020 Kirill Anisimov. All rights reserved.
//

import UIKit

class SelfyViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    var image: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
}
