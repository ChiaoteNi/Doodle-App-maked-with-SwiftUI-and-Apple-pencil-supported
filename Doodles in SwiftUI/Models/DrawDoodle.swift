//
//  DrawDoodle.swift
//  Doodles in SwiftUI
//
//  Created by 倪僑德 on 2021/12/24.
//

import CoreGraphics
import Foundation

struct DrawPath {
    // Touch
    let altitudeAngle: CGFloat
    let force: CGFloat
    
    // location
    let location: CGPoint
    let previousLocation: CGPoint
    
    //
    let width: CGFloat
    let alpha: CGFloat
}

struct DrawLine {
    let paintColor: DoodleColor
    let paintBrush: DoodleBrush
    let frame: CGRect
    
    var paths: [DrawPath]
}

final class DrawDoodle: Identifiable, ObservableObject {
    let id: String
    fileprivate(set) var isInOneColor: Bool
    fileprivate(set) var isInOneBrush: Bool
    var frame: CGRect
    fileprivate(set) var lines: [DrawLine]
    var rotationDegree: CGFloat = 0
    var scale: CGFloat = 1
    fileprivate(set) var zPriority: Double = 0
    
    var isFocus: Bool = false
    
    init(id: String, isInOneColor: Bool, isInOneBrush: Bool, frame: CGRect, lines: [DrawLine]) {
        self.id = id
        self.isInOneColor = isInOneColor
        self.isInOneBrush = isInOneBrush
        self.frame = frame
        self.lines = lines
    }
}

struct DoodleManipulator {
    
    private let frameCalculator: RectCalculator = RectCalculator()
    
//    func addLines(to doodle: DrawDoodle, with lines: [DrawLine]) {
//        guard let firstElement = lines.first else { return }
//        doodle.lines.append(contentsOf: lines)
//
//        let result = makePointsAndGetInfo(with: lines)
//        if doodle.isInOneBrush {
//            doodle.isInOneBrush = doodle.lines && lines.
//        }
//
//        doodle.isInOneColor = result.isInOneColor
//
//        frameCalculator.setLocations(result.points)
//        doodle.frame = frameCalculator.exportNecessaryRect()
//        frameCalculator.reset()
//    }
    
//    func resetLines(of doodle: DrawDoodle, to lines: [DrawLine]) {
//        doodle.lines = lines
//
//        let result = makePointsAndGetInfo(with: lines)
//        doodle.isInOneBrush = result.isInOneBrush
//        doodle.isInOneColor = result.isInOneColor
//
//        frameCalculator.setLocations(result.points)
//        doodle.frame = frameCalculator.exportNecessaryRect()
//        frameCalculator.reset()
//    }
    
    func setFocus(_ doodle: DrawDoodle) {
        doodle.zPriority = Double(Date().timeIntervalSince1970)
        doodle.isFocus = true
    }
}

extension DoodleManipulator {
    
    private func makePointsAndGetInfo(
        with lines: [DrawLine]
    ) -> (points: [CGPoint], isInOneColor: Bool, isInOneBrush: Bool) {
        
        guard let firstLine = lines.first else { return ([], true, true) }
        
        var isInOneColor = true
        var isInOneBrush = true
        var pts: [CGPoint] = []
        
        for line in lines {
            pts.append(contentsOf: makePoints(with: line))
            if isInOneColor {
                isInOneColor = line.paintColor == firstLine.paintColor
            }
            if isInOneBrush {
                isInOneBrush = line.paintBrush == firstLine.paintBrush
            }
        }
        
        return (pts, isInOneColor, isInOneBrush)
    }
    
    private func makePoints(with line: DrawLine) -> [CGPoint] {
        let minPt = line.frame.origin
        let maxPt = CGPoint(
            x: line.frame.maxX,
            y: line.frame.maxY
        )
        return [minPt, maxPt]
    }
}
