//
//  AppMain.swift
//  MiMoSimApp
//
//  Created by Nguyen Dinh Cong on 2020/06/13.
//  Copyright © 2020 Cong Nguyen. All rights reserved.
//

import AppKit

class AppMain {
    private var statusBarItem: NSStatusItem!
    
    private var mainWindow: WheelWindow = {
        let frame = NSRect(x: 0, y: 0, width: 100, height: 100)
        let window = WheelWindow(contentRect: frame, styleMask: .borderless, backing: .buffered, defer: false)
        window.collectionBehavior = .moveToActiveSpace
        window.backgroundColor = .clear
        window.level = .statusBar
        window.makeKeyAndOrderFront(nil)
        window.alphaValue = 0
        return window
    }()

    /// The center point in the Cocoa coodinate system (which has origin in the bottom-left)
    private var centerPoint: NSPoint?

    /// The center point in the Cocoa coodinate system (which has origin in the bottom-left)
    private var prevPoint: NSPoint?

    private var mimoState: MiMoState = .awaiting {
        didSet {
            switch mimoState {
            case .awaiting:
                mainWindow.alphaValue = 0
                
                /// Inactivate the app to ultilize the `.moveToActiveSpace` collectionBehavior of the window.
                NSApp.hide(NSApp)
            case .listening:
                break
            case .running:
                NSApp.activate(ignoringOtherApps: true)
                mainWindow.alphaValue = 1
            }
        }
    }
    
    init() {
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        let icon = NSImage(named: "statusIcon")
        icon?.isTemplate = true
        statusBarItem.button?.image = icon
        
        let menu = NSMenu(title: "MiMoSim")
        statusBarItem.menu = menu
        
        menu.addItem(withTitle: "Quit", action: #selector(performTerminate), keyEquivalent: "")
        
        if !AXIsProcessTrusted() {
            print("Could not start event monitoring.")
        }

        let eventMask = CGEventMask((1 << CGEventType.mouseMoved.rawValue)
            | (1 << CGEventType.flagsChanged.rawValue)
            | (1 << CGEventType.keyDown.rawValue))
        
        let eventTap = CGEvent.tapCreate(
            tap: .cghidEventTap,
            place: .headInsertEventTap,
            options: .defaultTap,
            eventsOfInterest: eventMask,
            callback: { (_, type, event, userInfo) -> Unmanaged<CGEvent>? in
                let obj = Unmanaged<AppMain>.fromOpaque(userInfo!).takeUnretainedValue()
                return obj.handleEventTap(type: type, event: event)
            },
            userInfo: UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque()))


        let runloopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runloopSource, CFRunLoopMode.commonModes)

        CFRunLoopRun()
    }
    
    @objc private func performTerminate() {
        NSApp.terminate(nil)
    }
}

private extension AppMain {
    func updateWheel(center: NSPoint, angle: CGFloat? = nil) {
        mainWindow.setFrameOrigin(.init(x: center.x - 50, y: center.y - 50))
        if let angle = angle {
            mainWindow.circle.frameCenterRotation += angle * 180 / .pi
        }
    }

    func emitScrolling(delta: Int32) {
        let event = CGEvent(
            scrollWheelEvent2Source: nil,
            units: .pixel,
            wheelCount: 1,
            wheel1: delta,
            wheel2: 0,
            wheel3: 0)
        guard let scrollEvent = event else { return }
        scrollEvent.post(tap: .cghidEventTap)
    }
    
    func handleEventTap(type: CGEventType, event: CGEvent) -> Unmanaged<CGEvent>? {
        if type == .flagsChanged, event.getIntegerValueField(.keyboardEventKeycode) == 62 {
            if mimoState == .awaiting {
                mimoState = .listening
            } else {
                mimoState = .awaiting
            }
        }

        guard mimoState != .awaiting else {
            if centerPoint != nil || prevPoint != nil {
                centerPoint = nil
                prevPoint = nil
            }
            return Unmanaged.passRetained(event)
        }
        
        /// The location in the the Cocoa coodinate system (which has origin in the bottom-left)
        let eventLocation = event.unflippedLocation
        
        guard let center = centerPoint else {
            centerPoint = eventLocation
            updateWheel(center: eventLocation)
            return Unmanaged.passRetained(event)
        }
        
        guard let prev = prevPoint else {
            if eventLocation.distance(to: center) > 25 {
                prevPoint = eventLocation
                mimoState = .running
            }
            return Unmanaged.passRetained(event)
        }
        
        let current = eventLocation
        
        let deltaAngle = current.angle(with: prev, anchor: center)
        
        let chordLen = Int32(deltaAngle * 300)
        
        
        if abs(chordLen) > 0 {
            emitScrolling(delta: chordLen)
            prevPoint = eventLocation
            updateWheel(center: center, angle: deltaAngle)
        }
        
        return Unmanaged.passRetained(event)
    }
}
