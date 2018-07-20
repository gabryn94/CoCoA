//
//  Double+Extension.swift
//  CoCoA
//
//  Created by Gabriele di rosa on 5/21/18.
//  Copyright © 2018 Gabriele di rosa. All rights reserved.
//

import Foundation

extension Double {
    
    var truncate: Double {
        return Double(floor(10 * self) / 10)
    }
    
}
