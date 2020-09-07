//
//  ApplicationCoordinator.swift
//  MyTracker
//
//  Created by Kirill Anisimov on 06.09.2020.
//  Copyright © 2020 Kirill Anisimov. All rights reserved.
//

import Foundation
import UIKit

final class ApplicationCoordinator: BaseCoordinator {
    
    override func start() {
        if UserDefaults.standard.bool(forKey: "isLogin") {
            toMain()
        } else {
            toAuth()
        }
    }
    
    private func toMain() {
// Создаём координатор главного сценария
        let coordinator = MainCoordinator()
// Устанавливаем ему поведение на завершение
       coordinator.onFinishFlow = { [weak self, weak coordinator] in
// Так как подсценарий завершился, держать его в памяти больше не нужно
            self?.removeDependency(coordinator)
// Заново запустим главный координатор, чтобы выбрать следующий сценарий
            self?.start()
        }
// Сохраним ссылку на дочерний координатор, чтобы он не выгружался из памяти
        addDependency(coordinator)
// Запустим сценарий дочернего координатора
        coordinator.start()
    }
    
    private func toAuth() {
// Создаём координатор сценария авторизации
        let coordinator = AuthCoordinator()
// Устанавливаем ему поведение на завершение
        coordinator.onFinishFlow = { [weak self, weak coordinator] in
// Так как подсценарий завершился, держать его в памяти больше не нужно
            self?.removeDependency(coordinator)
// Заново запустим главный координатор, чтобы выбрать выбрать следующий
// сценарий
            self?.start()
        }
// Сохраним ссылку на дочерний координатор, чтобы он не выгружался из памяти
        addDependency(coordinator)
// Запустим сценарий дочернего координатора
        coordinator.start()
    }
}
