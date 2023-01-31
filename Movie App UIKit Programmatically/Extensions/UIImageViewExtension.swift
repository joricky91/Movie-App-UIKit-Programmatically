//
//  UIImageViewExtension.swift
//  Movie App UIKit Programmatically
//
//  Created by Jonathan Ricky Sandjaja on 31/01/23.
//

import Foundation
import UIKit

extension UIImageView {
    func downloadImage(from url: URL, contentMode mode: ContentMode = .scaleToFill) {
        contentMode = mode
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let data = data, error == nil,
                let image = UIImage(data: data)
            else {
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.image = image
            }
        }
        .resume()
    }
    
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleToFill) {
        guard let url = URL(string: link) else { return }
        downloadImage(from: url, contentMode: mode)
    }
}
