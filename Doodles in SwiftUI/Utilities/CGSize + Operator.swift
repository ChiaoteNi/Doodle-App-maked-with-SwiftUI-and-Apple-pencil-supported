//
//  CGSize + Operator.swift
//  Doodles in SwiftUI
//
//  Created by 倪僑德 on 2021/12/28.
//

import CoreGraphics

extension CGSize {
    static func - (_ lhs: CGSize, _ rhs: CGSize) -> CGSize {
        CGSize(
            width: lhs.width - rhs.width,
            height: lhs.height - rhs.height
        )
    }
    
    static func + (_ lhs: CGSize, _ rhs: CGSize) -> CGSize {
        CGSize(
            width: lhs.width + rhs.width,
            height: lhs.height + rhs.height
        )
    }
}
