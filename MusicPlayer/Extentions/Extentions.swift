//
//  Extentions.swift
//  MusicPlayer
//
//  Created by Akash on 05/04/24.
//

import Foundation
import UIKit

extension UIImage{
    func resizeImage(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}

