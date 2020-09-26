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
    var onTakePicture: ((UIImage) -> Void)?
    
    let selfieMarker = SelfieMarker()
    
    @IBOutlet weak var avatarView: UIImageView!
    @IBAction func showMap(_ sender: Any) {
        onMap?("map")
    }
    
    @IBAction func logout(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "isLogin")
        onLogout?()
    }

    @IBAction func takePicture(_ sender: Any) {
        // Проверка, поддерживает ли устройство камеру
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary/*.camera*/) else { return }
        // Создаём контроллер и настраиваем его
        let imagePickerController = UIImagePickerController()
        // Источник изображений: камера
        imagePickerController.sourceType = .photoLibrary//.camera
        // Изображение можно редактировать
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        
        // Показываем контроллер
        present(imagePickerController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        avatarView.image = selfieMarker.loadImageFromDiskWith(fileName: "selfie.png")
    }
}

extension MainViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Если нажали на кнопку Отмена, то UIImagePickerController надо закрыть
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Закрываем UIImagePickerController
        picker.dismiss(animated: true) { [weak self] in
            // После того, как он закроется, извлечём изображение
            guard let image = self?.extractImage(from: info) else { return }
            // Если оно будет извлечено, выполним действие на его получение
            self?.avatarView.image = image
            self?.selfieMarker.saveImage(imageName: "selfie.png", image: image)
            
//            self?.onTakePicture?(image)
        }
    }
    // Метод, извлекающий изображение
    private func extractImage(from info: [UIImagePickerController.InfoKey : Any]) -> UIImage? {
        // Пытаемся извлечь отредактированное изображение
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            return image
            // Пытаемся извлечь оригинальное
        } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            return image
        } else {
            // Если изображение не получено, возвращаем nil
            return nil
        }
    }
}
