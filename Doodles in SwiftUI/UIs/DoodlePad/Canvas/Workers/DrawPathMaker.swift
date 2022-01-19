//
//  DrawPathMaker.swift
//  Doodles in SwiftUI
//
//  Created by 倪僑德 on 2021/12/26.
//

import UIKit

struct DrawPathMaker {

    private final class TouchProxy: UITouch {
        override var force: CGFloat { _force }
        override var altitudeAngle: CGFloat { touch.altitudeAngle }
        override var view: UIView? { touch.view }

        private let touch: UITouch
        private let _force: CGFloat

        init(wrappedValue: UITouch, force: CGFloat) {
            self.touch = wrappedValue
            self._force = force
        }

        override func location(in view: UIView?) -> CGPoint {
            touch.location(in: view)
        }

        override func previousLocation(in view: UIView?) -> CGPoint {
            touch.previousLocation(in: view)
        }
    }
    
    private let defaultLineWidth: CGFloat = 8
    private let minLineWidth: CGFloat = 3
    private let forceSensitivity: CGFloat = 10
    private let tiltThreshold: CGFloat = .pi / 6

    /// makePaths and call back when the touch is valid
    /// - Parameters:
    ///   - touches: UITouches we want to handle
    ///   - didMakePathWithTouch: call back when the touch is valid and make a path successful with it
    ///   - touchProxy: a proxy to fix the force value for the origin touch, only the following properties works
    ///     - force
    ///     - altitudeAngle
    ///     -  view
    ///     - location(in:)
    ///     - previousLocation(in:)
    /// - Returns: path make with the touches
    func makePaths(
        with touches: [UITouch],
        didMakePathWithTouch: ((_ touchProxy: UITouch, _ path: DrawPath) -> Void)? = nil
    ) -> [DrawPath] {

        guard let first = touches.first else { return [] }
        var currentValidTouch: UITouch = first
        var currentValidForce = first.force
        var currentSlope: CGFloat = 0

        return touches.compactMap { touch -> DrawPath? in
            let previousLocation = currentValidTouch.location(in: currentValidTouch.view)
            let location = touch.location(in: touch.view)

            // filter unnecessary touch
            let slope = previousLocation.slope(location)
            if slope == currentSlope {
                return nil
            } else {
                currentSlope = slope
            }

            // filter incorrect force
            var force: CGFloat = touch.force
            if currentValidForce != 0, force == 0 {
                force = currentValidForce
            } else {
                currentValidForce = force
            }

            let request: MakePathRequest = MakePathRequest(
                altitudeAngle: touch.altitudeAngle,
                force: force,
                location: touch.location(in: touch.view),
                previousLocation: currentValidTouch.location(in: currentValidTouch.view)
            )

            let validTouch = TouchProxy(wrappedValue: touch, force: force)
            let path = makeDrawPath(with: request)
            currentValidTouch = validTouch
            didMakePathWithTouch?(validTouch, path)
            return path
        }
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
}

// MARK: - Private functions
extension DrawPathMaker {

    private struct MakePathRequest {
        let altitudeAngle: CGFloat
        let force: CGFloat
        let location: CGPoint
        let previousLocation: CGPoint
    }

    private func makeDrawPath(with request: MakePathRequest) -> DrawPath {
        let altitudeAngle = request.altitudeAngle
        let force = request.force

        let lineWidth: CGFloat
        let alpha: CGFloat

        if altitudeAngle < tiltThreshold {
            lineWidth = makeLineWidthForShading(altitudeAngle: altitudeAngle)
            alpha = makeAlphaForShading(force: force)
        } else {
            if force == 0 {
                lineWidth = defaultLineWidth
            } else {
                lineWidth = force * forceSensitivity
            }
            alpha = 1
        }

        return DrawPath(
            altitudeAngle: altitudeAngle,
            force: force,
            location: request.location,
            previousLocation: request.previousLocation,
            width: lineWidth,
            alpha: alpha
        )
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

private extension CGPoint {

    func slope(_ point: CGPoint) -> CGFloat {
        let diffX = x - point.x
        let diffY = y - point.y
        return x == 0 ? 0 : diffY / diffX
    }
}
