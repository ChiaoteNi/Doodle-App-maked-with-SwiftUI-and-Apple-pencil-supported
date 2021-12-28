//
//  DrawLineMaker.swift
//  Doodles in SwiftUI
//
//  Created by 倪僑德 on 2021/12/27.
//

import Foundation
import CoreGraphics

final class RectCalculator {
    private var minLocation: CGPoint = Constants.minLocation
    private var maxLocation: CGPoint = Constants.maxLocation
    
    func setLocations(_ points: [CGPoint]) {
        guard points.isEmpty == false else { return }
        minLocation = makeMinPoint(with: points)
        maxLocation = makeMaxPoint(with: points)
    }
    
    func exportNecessaryRect() -> CGRect {
        guard maxLocation != Constants.maxLocation,
                minLocation != Constants.minLocation else { return .zero }
        let size = makeSize(minPoint: minLocation, maxPoint: maxLocation)
        return CGRect(origin: minLocation, size: size)
    }
    
    func reset() {
        maxLocation = Constants.maxLocation
        minLocation = Constants.minLocation
    }
}

// MARK: - Private functions
extension RectCalculator {
    
    private func makeMaxPoint(with points: [CGPoint]) -> CGPoint {
        points.reduce(into: maxLocation) {
            $0 = CGPoint(
                x: max($0.x, $1.x),
                y: max($0.y, $1.y)
            )
        }
    }
    
    private func makeMinPoint(with points: [CGPoint]) -> CGPoint {
        points.reduce(into: minLocation) {
            $0 = CGPoint(
                x: max(0, min($0.x, $1.x)),
                y: max(0, min($0.y, $1.y))
            )
        }
    }
    
    private func makeSize(minPoint: CGPoint, maxPoint: CGPoint) -> CGSize {
        CGSize(
            width: maxPoint.x - minPoint.x,
            height: maxPoint.y - minPoint.y
        )
    }
}

// MARK: - Constants
extension RectCalculator {
    
    private enum Constants {
        static var minLocation: CGPoint { CGPoint(x: CGFloat.infinity, y: CGFloat.infinity) }
        static var maxLocation: CGPoint { .zero }
    }
}
