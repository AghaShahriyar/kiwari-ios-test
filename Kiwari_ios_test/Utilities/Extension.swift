//
//  Extension.swift
//  Kiwari_ios_test
//
//  Created by macbook on 21/02/2020.
//  Copyright © 2020 AghaShahriyarKhan. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func presentAlert(_ message:String,_ alertTitle:String) {
        let alerController = UIAlertController.init(title: alertTitle, message: message, preferredStyle: .alert)
        alerController.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
        self.present(alerController, animated: true, completion: nil)
    }
    
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
