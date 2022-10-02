//
//  Extension + UIImageView.swift
//  Test-task
//
//  Created by zz on 02.10.2022.
//

import UIKit

extension UIImageView {
    func downloadImage(_ url: String) {
        contentMode = .scaleAspectFill
        guard let url = URL(string: url) else {
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == Constants.statusCode,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
}
