//
//  Application.swift
//  MiMoSimApp
//
//  Created by Nguyen Dinh Cong on 2020/06/13.
//  Copyright © 2020 Cong Nguyen. All rights reserved.
//

import AppKit

class Application: NSApplication {
    let strongDelegate = AppDelegate()
    
    override init() {
        super.init()
        self.delegate = strongDelegate
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
