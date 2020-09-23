//
//  NotificationManager.swift
//  MyTracker
//
//  Created by Kirill Anisimov on 21.09.2020.
//  Copyright © 2020 Kirill Anisimov. All rights reserved.
//

import UserNotifications

class NotificationManager {
    
    static let instance = NotificationManager()
    
    func makeNotificationContent(title: String, subtitle: String, body: String) -> UNNotificationContent {
// Внешний вид уведомления
        let content = UNMutableNotificationContent()
// Заголовок
        content.title = title
// Подзаголовок
        content.subtitle = subtitle
// Основное сообщение
        content.body = body
// Цифра в бейдже на иконке
        content.badge = 1
        return content
    }
    
    func makeIntervalNotificatioTrigger(min: Double) -> UNNotificationTrigger {
        return UNTimeIntervalNotificationTrigger(
// Количество секунд до показа уведомления
            timeInterval: min * 60,
// Надо ли повторять
            repeats: false
        )
    }
    
    func sendNotificatioRequest(
        content: UNNotificationContent,
        trigger: UNNotificationTrigger) {
        
// Создаём запрос на показ уведомления
        let request = UNNotificationRequest(
            identifier: "alarm",
            content: content,
            trigger: trigger
        )
        
        let center = UNUserNotificationCenter.current()
// Добавляем запрос в центр уведомлений
        center.add(request) { error in
// Если не получилось добавить запрос,
// показываем ошибку, которая при этом возникла
            if let error = error {
                print(error.localizedDescription)
             }
         }
     }
    
}
