//
//  Models.swift
//  MiMoSimApp
//
//  Created by Nguyen Dinh Cong on 2020/06/13.
//  Copyright © 2020 Cong Nguyen. All rights reserved.
//

import Foundation

enum MiMoState {
    /// Waiting for the first sign of key pressing to decide the center point.
    case awaiting
    
    /// Listening unil mouse moved a large enough distance to start runing.
    case listening
    
    /// Converting the mouse moves into scroll events.
    case running
}

enum Quadrant {
    case first
    case second
    case third
    case forth
}
