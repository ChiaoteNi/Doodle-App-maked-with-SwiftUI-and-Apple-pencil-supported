//
//  CanvasController.swift
//  Doodles in SwiftUI
//
//  Created by 倪僑德 on 2021/12/26.
//

import UIKit
import SwiftUI

protocol DoodleStorageLogic {
    var doodle: DrawDoodle? { get }
    func updateDoodle(_ doodle: DrawDoodle)
    func clearDoodle()
}

protocol CanvasBusinessLogic {
    func startTouching(_ touches: [UITouch], in rect: CGRect)
    func touchesMoved(_ touches: [UITouch])
    func touchEnd()
    func updateSetting(color: DoodleColor, brush: DoodleBrush)
    func makeDoodle()
    func clear()
}

final class CanvasController: CanvasBusinessLogic {
    
    // Brush Settings
    private var currentColor: DoodleColor = .blue
    private var currentBrush: DoodleBrush = .marker
    
    // Current Value
    private var currentLine: DrawLine?
    private var currentPaths: [DrawPath]? {
        set { currentLine?.paths = newValue ?? [] }
        get { currentLine?.paths }
    }
    
    // Depended-on Component
    weak var view: CanvasDisplayLogic?
    var store: DoodleStorageLogic?
    private let pathMaker: DrawPathMaker
    private let doodleMaker: DrawDoodleMaker
    private let frameCalculator: RectCalculator
    private let handleQueue = DispatchQueue(label: "com.Canvas.BusinessLogic")
    
    init(
        view: CanvasDisplayLogic? = nil,
        store: DoodleStorageLogic? = nil,
        pathMaker: DrawPathMaker = DrawPathMaker(),
        doodleMaker: DrawDoodleMaker = DrawDoodleMaker(),
        frameCalculator: RectCalculator = RectCalculator()
    ) {
        self.view = view
        self.store = store
        self.pathMaker = pathMaker
        self.doodleMaker = doodleMaker
        self.frameCalculator = frameCalculator
    }
    
    // MARK: - CanvasBusinessLogic
    
    func startTouching(_ touches: [UITouch], in rect: CGRect) {
        handleQueue.async { [weak self] in
            guard let self = self else { return }
            let paths = self.updateLocationAndMakePaths(touches)
            self.currentLine = DrawLine(
                paintColor: self.currentColor,
                paintBrush: self.currentBrush,
                frame: rect,
                paths: paths
            )
        }
    }
    
    func touchesMoved(_ touches: [UITouch]) {
        handleQueue.async { [weak self] in
            guard let self = self else { return }
            guard let line = self.currentLine else { return }
            let paths = self.updateLocationAndMakePaths(touches)
            self.currentPaths?.append(contentsOf: paths)
            self.view?.displayNewDrawing(
                paths,
                color: line.paintColor.uiColor,
                brush: line.paintBrush
            )
        }
    }
    
    func touchEnd() {
        print("💧")
        handleQueue.async { [weak self] in
            guard let self = self else { return }
            guard let currentLine = self.currentLine else { return }
            
            let necessaryRect = self.frameCalculator.exportNecessaryRect()
            let line = DrawLine(
                paintColor: currentLine.paintColor,
                paintBrush: currentLine.paintBrush,
                frame: necessaryRect,
                paths: self.pathMaker.makeDrawPaths(
                    from: currentLine.paths,
                    offset: -necessaryRect.origin
                )
            )
            self.frameCalculator.reset()
            self.doodleMaker.setNewLine(line)
            self.currentLine = nil
        }
    }
    
    func updateSetting(color: DoodleColor, brush: DoodleBrush) {
        handleQueue.async { [weak self] in
            self?.currentColor = color
            self?.currentBrush = brush
        }
    }
    
    func makeDoodle() {
        handleQueue.async { [weak self] in
            guard let doodle = self?.doodleMaker.makeDoodle() else { return }
            self?.store?.updateDoodle(doodle)
            self?.view?.displayDoodle(doodle)
        }
    }
    
    func clear() {
        doodleMaker.clearLines()
        frameCalculator.reset()
        currentLine = nil
    }
}

// MARK: - Private functions.
extension CanvasController {

    private func updateLocationAndMakePaths(_ touches: [UITouch]) -> [DrawPath] {
        var currentValidatePath: DrawPath?
        var currentSlope: CGFloat = 0
        return touches.compactMap {
            var path = pathMaker.makeDrawPath(with: $0)

            if let currentPath = currentValidatePath {
                let slope = currentPath.location.slope(path.location)
                if slope == currentSlope {
                    return nil
                } else {
                    path.previousLocation = currentPath.location
                    currentSlope = slope
                    currentValidatePath = path
                    frameCalculator.setLocations([path.location])
                    return path
                }
            } else {
                currentValidatePath = path
                frameCalculator.setLocations([path.location])
                return path
            }
        }
    }
}

private extension CGPoint {

    func slope(_ point: CGPoint) -> CGFloat {
        let diffX = x - point.x
        let diffY = y - point.y
        return x == 0 ? 0 : diffY / diffX
    }
}
