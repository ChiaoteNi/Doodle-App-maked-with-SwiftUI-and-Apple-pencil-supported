//
//  Painter.swift
//  Doodles in SwiftUI
//
//  Created by 倪僑德 on 2021/12/26.
//

import Foundation
import UIKit

struct Painter {
    
    func draw(
        _ paths: [DrawPath],
        in rect: CGRect,
        pathOffset offset: CGPoint = .zero,
        canvasRect: CGRect,
        backgroundImage: UIImage?,
        color: UIColor,
        brush: DoodleBrush,
        lineWidthDiff: CGFloat = 0
    ) -> UIImage {
        UIGraphicsImageRenderer(size: canvasRect.size).image { context in
            UIColor.white.withAlphaComponent(0).setFill()
            context.fill(rect)
            backgroundImage?.draw(in: canvasRect)

            paths.forEach {
                drawStroke(
                    context: context.cgContext,
                    path: $0,
                    tintColor: brush.getBrushTintColor(with: color),
                    offset: offset,
                    lineWidthDiff: lineWidthDiff
                )
            }
         }
    }
    
    private func drawStroke(
        context: CGContext,
        path: DrawPath,
        tintColor: UIColor,
        offset: CGPoint,
        lineWidthDiff: CGFloat
    ){
        let previousLocation = path.previousLocation + offset
        let location = path.location + offset
        
        tintColor.set()
        context.setAlpha(path.alpha)
        context.setLineWidth(path.width + lineWidthDiff)
        context.setLineCap(.round)
            context.move(to: previousLocation)
        context.addLine(to: location)
        context.strokePath()
    }
}
