//
//  WheelWindow.swift
//  MiMoSimApp
//
//  Created by Nguyen Dinh Cong on 2020/06/13.
//  Copyright © 2020 Cong Nguyen. All rights reserved.
//

import AppKit

class WheelWindow: NSWindow {
    weak var circle: NSView!
    
    override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag)
        
        let view = NSView()
        contentView = view
        view.wantsLayer = true
        view.layer!.backgroundColor = .clear
        
        let circle = NSView(frame: CGRect(x: 25, y: 25, width: 50, height: 50))
        self.circle = circle
        view.addSubview(circle)
        circle.wantsLayer = true
        circle.layer!.backgroundColor = .white
        circle.layer!.cornerRadius = 25
        circle.shadow = NSShadow()
        circle.layer!.shadowPath = NSBezierPath(roundedRect: circle.bounds, xRadius: circle.bounds.width / 2, yRadius: circle.bounds.height / 2).cgPath
        circle.layer!.shadowRadius = 2
        circle.layer!.shadowOpacity = 1
        circle.layer!.shadowColor = .black
        
        let dot = NSView(frame: .init(x: 5, y: 22.5, width: 5, height: 5))
        circle.addSubview(dot)
        dot.wantsLayer = true
        dot.layer!.backgroundColor = NSColor.red.cgColor
        dot.layer!.cornerRadius = 2.5
        dot.shadow = NSShadow()
        dot.layer!.shadowPath = NSBezierPath(roundedRect: dot.bounds, xRadius: dot.bounds.width / 2, yRadius: dot.bounds.height / 2).cgPath
        dot.layer!.shadowRadius = 0.5
        dot.layer!.shadowOpacity = 1
        dot.layer!.shadowColor = .black
        
        let centerDot = NSView(frame: .init(x: 24, y: 24, width: 2, height: 2))
        circle.addSubview(centerDot)
        centerDot.wantsLayer = true
        centerDot.layer!.backgroundColor = NSColor.darkGray.cgColor
        centerDot.layer!.cornerRadius = 1
        centerDot.shadow = NSShadow()
        centerDot.layer!.shadowPath = NSBezierPath(roundedRect: centerDot.bounds, xRadius: centerDot.bounds.width / 2, yRadius: centerDot.bounds.height / 2).cgPath
        centerDot.layer!.shadowRadius = 0.5
        centerDot.layer!.shadowOpacity = 1
        centerDot.layer!.shadowColor = .black
    }
}
