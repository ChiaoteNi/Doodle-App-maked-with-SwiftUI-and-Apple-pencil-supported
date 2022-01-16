//
//  DrawPathMaker.swift
//  Doodles in SwiftUI
//
//  Created by 倪僑德 on 2021/12/26.
//

import UIKit

struct DrawPathMaker {
    
    private let defaultLineWidth: CGFloat = 8
    private let minLineWidth: CGFloat = 3
    private let forceSensitivity: CGFloat = 10
    private let tiltThreshold: CGFloat = .pi / 6
    
    func makeDrawPath(with touch: UITouch) -> DrawPath {
        let altitudeAngle: CGFloat = touch.altitudeAngle
        let force: CGFloat = touch.force
        
        let lineWidth: CGFloat
        let alpha: CGFloat
    
        if altitudeAngle < tiltThreshold {
            lineWidth = makeLineWidthForShading(altitudeAngle: altitudeAngle)
            alpha = makeAlphaForShading(force: force)
        } else {
            if touch.force > 0 {
                lineWidth = force * forceSensitivity
            } else {
                lineWidth = defaultLineWidth
            }
            alpha = 1
        }
        
        return DrawPath(
            altitudeAngle: altitudeAngle,
            force: force,
            location: touch.location(in: touch.view),
            previousLocation: touch.previousLocation(in: touch.view),
            width: lineWidth,
            alpha: alpha
        )
    }
    
    func makeDrawPaths(from paths: [DrawPath], offset: CGPoint) -> [DrawPath] {
        paths.map { path in
            DrawPath(
                altitudeAngle: path.altitudeAngle,
                force: path.force,
                location: path.location + offset,
                previousLocation: path.previousLocation + offset,
                width: path.width,
                alpha: path.alpha
            )
        }
    }
    
    private func makeLineWidthForShading(altitudeAngle: CGFloat) -> CGFloat {
        let maxLineWidth: CGFloat = 60
        let minAltitudeAngle: CGFloat = 0.25
        let maxAltitudeAngle = tiltThreshold
        let altitudeAngle = max(minAltitudeAngle, altitudeAngle)
        
        let normalizedAltitude = (altitudeAngle - minAltitudeAngle) / (maxAltitudeAngle - minAltitudeAngle)
        
        return max(maxLineWidth * (1 - normalizedAltitude), minLineWidth)
    }
    
    private func makeAlphaForShading(force: CGFloat) -> CGFloat {
        let minForce: CGFloat = 0
        let maxForce: CGFloat = 4
        return (force - minForce) / (maxForce - minForce)
    }
}
