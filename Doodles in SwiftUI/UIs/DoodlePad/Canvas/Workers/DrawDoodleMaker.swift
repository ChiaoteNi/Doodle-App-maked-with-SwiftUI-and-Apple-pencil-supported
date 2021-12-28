//
//  DrawDoodleMaker.swift
//  Doodles in SwiftUI
//
//  Created by 倪僑德 on 2021/12/26.
//

import CoreGraphics
import Foundation

final class DrawDoodleMaker {
    
    private let doodleID = UUID().uuidString
    private var lines: [DrawLine] = []
    
    private let frameCalculator = RectCalculator()
    
    func setNewLine(_ line: DrawLine) {
        lines.append(line)
        
        let frame = line.frame
        frameCalculator.setLocations([
            CGPoint(x: frame.minX, y: frame.minY),
            CGPoint(x: frame.maxX, y: frame.maxY),
        ])
    }
    
    func makeDoodle() -> DrawDoodle? {
        guard let info = getDoodleInfo(from: lines) else { return nil }
        
        let necessaryRect = frameCalculator.exportNecessaryRect()
        let lines = lines.map { line -> DrawLine in
            let frame = CGRect(
                origin: line.frame.origin - necessaryRect.origin,
                size: line.frame.size
            )
            return DrawLine(
                paintColor: line.paintColor,
                paintBrush: line.paintBrush,
                frame: frame,
                paths: line.paths
            )
        }
        
        return DrawDoodle(
            id: doodleID,
            isInOneColor: info.isInOneColor,
            isInOneBrush: info.isInOneBrush,
            frame: necessaryRect,
            lines: lines
        )
    }
    
    func clearLines() {
        lines.removeAll()
        frameCalculator.reset()
    }
}

// MARK: - Private functions
extension DrawDoodleMaker {
    
    private func getDoodleInfo(
        from lines: [DrawLine]
    ) -> (isInOneColor: Bool, isInOneBrush: Bool)? {
        
        guard let firstLine = lines.first else { return nil }
        var isInOneColor = true
        var isInOneBrush = true
        
        for line in lines {
            if isInOneBrush {
                isInOneBrush = line.paintBrush == firstLine.paintBrush
            }
            if isInOneColor {
                isInOneColor = line.paintColor == firstLine.paintColor
            }
            
            if isInOneColor == false && isInOneBrush == false { break }
        }
        
        return (isInOneColor, isInOneBrush)
    }
}
