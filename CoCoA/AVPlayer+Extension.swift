//
//  AVPlayer+Extension.swift
//  CoCoA
//
//  Created by Gabriele di rosa on 5/18/18.
//  Copyright © 2018 Gabriele di rosa. All rights reserved.
//

import Foundation
import AVFoundation

extension AVPlayer {
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}
