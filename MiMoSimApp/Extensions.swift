//
//  Extension.swift
//  MiMoSimApp
//
//  Created by Nguyen Dinh Cong on 2020/06/13.
//  Copyright © 2020 Cong Nguyen. All rights reserved.
//

import AppKit

extension NSBezierPath {
    public var cgPath: CGPath {
        let path = CGMutablePath()
        var points = [CGPoint](repeating: .zero, count: 3)

        for i in 0 ..< self.elementCount {
            let type = self.element(at: i, associatedPoints: &points)
            switch type {
            case .moveTo:
                path.move(to: points[0])
            case .lineTo:
                path.addLine(to: points[0])
            case .curveTo:
                path.addCurve(to: points[2], control1: points[0], control2: points[1])
            case .closePath:
                path.closeSubpath()
            @unknown default:
                break
            }
        }

        return path
    }
}

extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        return sqrt(pow(x - point.x, 2) + pow(y - point.y, 2))
    }
    
    func distanceX(to point: CGPoint) -> CGFloat {
        return abs(x - point.x)
    }
    
    func distanceY(to point: CGPoint) -> CGFloat {
        return abs(y - point.y)
    }
    
    func quadrant(center: CGPoint) -> Quadrant {
        let shiftedX = x - center.x
        let shiftedY = y - center.y
        
        switch (shiftedX >= 0, shiftedY >= 0) {
        case (true, true): return .forth
        case (true, false): return .first
        case (false, true): return .third
        case (false, false): return .second
        }
    }
    
    func angle(center: CGPoint) -> CGFloat {
        let arcsin = asin(distanceY(to: center) / distance(to: center))
        let arccos = acos(distanceY(to: center) / distance(to: center))
        
        let angle: CGFloat
        switch quadrant(center: center) {
        case .first:
            angle = arcsin
        case .second:
            angle =  0.5 * .pi + arccos
        case .third:
            angle =  .pi + arcsin
        case .forth:
            angle =  1.5 * .pi + arccos
        }
        return angle
    }
    
    func angle(with point: CGPoint, anchor center: CGPoint) -> CGFloat {
        let angle1 = angle(center: center)
        let angle2 = point.angle(center: center)
        
        if quadrant(center: center) == .first, point.quadrant(center: center) == .forth {
            return 2 * .pi - angle2 + angle1
        }
        
        if quadrant(center: center) == .forth, point.quadrant(center: center) == .first {
            return 2 * .pi - angle1 + angle2
        }
        
        return angle2 - angle1
    }
}
