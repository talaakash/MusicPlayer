//
//  UILabel+Extention.swift
//  MusicPlayer
//
//  Created by Akash on 05/04/24.
//

import Foundation
import UIKit

extension UILabel {
    @IBInspectable
    var setImage: UIImage? {
        get {
            return nil
        }
        set {
            let image = newValue?.resizeImage(to: self.frame.size)
            let color = UIColor(patternImage: image ?? UIImage())
            self.textColor = color
        }
    }
}
