//
//  AppDelegate.swift
//  MiMoSimApp
//
//  Created by Nguyen Dinh Cong on 2020/06/08.
//  Copyright © 2020 Cong Nguyen. All rights reserved.
//

import Cocoa
import AppKit
import CoreGraphics
import Foundation

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    private var appMain: AppMain!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        appMain = AppMain()
    }
}
