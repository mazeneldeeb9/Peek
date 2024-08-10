//
//  UIImageViewExtension.swift
//  Peek
//
//  Created by mazen eldeeb on 10/08/2024.
//

import UIKit

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) { DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

