//
//  MainCoordinator.swift
//  MyTracker
//
//  Created by Kirill Anisimov on 06.09.2020.
//  Copyright © 2020 Kirill Anisimov. All rights reserved.
//

import Foundation
import UIKit

final class MainCoordinator: BaseCoordinator {
    
    var rootController: UINavigationController?
    var onFinishFlow: (() -> Void)?
    
    override func start() {
        showMainModule()
    }
    
    private func showMainModule() {
        let controller = UIStoryboard(name: "Main", bundle: nil) .instantiateViewController(MainViewController.self)
        
        controller.onMap = { [weak self] usseles in
            self?.showMapModule(usseles: usseles)
        }
        
        controller.onLogout = { [weak self] in
            self?.onFinishFlow?()
        }
        
        controller.onTakePicture = { [weak self] image in
            self?.funcShowSelfyModule(image: image)
        }
        
        let rootController = UINavigationController(rootViewController: controller)
        setAsRoot(rootController)
        self.rootController = rootController
    }
    
    private func showMapModule(usseles: String) {
        let controller = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(MapViewController.self)
        
        controller.usselesExampleVariable = usseles
        
        rootController?.pushViewController(controller, animated: true)
    }
    
    private func funcShowSelfyModule(image: UIImage) {
        let controller = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(SelfyViewController.self)
        
        controller.image = image
        rootController?.pushViewController(controller, animated: true)
    }
    
}
