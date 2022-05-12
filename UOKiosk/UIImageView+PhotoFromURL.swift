//
//  UIImageView+PhotoFromURL.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 5/11/22.
//

import SwiftUI

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    self?.image = image
                }
            }
        }
    }
}
