//
//  CGPoint + Operator.swift
//  Doodles in SwiftUI
//
//  Created by 倪僑德 on 2021/12/27.
//

import CoreGraphics

extension CGPoint {
    static func - (_ lhs: CGPoint, _ rhs: CGPoint) -> CGPoint {
        CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    
    static func + (_ lhs: CGPoint, _ rhs: CGPoint) -> CGPoint {
        CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    static func += (_ lhs: inout CGPoint, _ rhs: CGPoint) {
        lhs.x += rhs.x
        lhs.y += rhs.y
    }
    
    static prefix func -(point: CGPoint) -> CGPoint {
        CGPoint(x: -point.x, y: -point.y)
    }
}
