//
//  UIView+Extension.swift
//  CoCoA
//
//  Created by Gabriele di rosa on 5/27/18.
//  Copyright © 2018 Gabriele di rosa. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func defaultShadow() {
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOffset = CGSize(width: 5, height: 5)
        layer.shadowRadius = 5
        layer.shadowOpacity = 1.0
    }
    
    func defaultBorder() {
        layer.cornerRadius = 10
        layer.borderColor = UIColor.darkGray.cgColor
        layer.borderWidth = 1
    }
    
}
