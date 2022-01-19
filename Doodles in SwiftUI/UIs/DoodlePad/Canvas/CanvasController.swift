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
    private var currentTouch: UITouch?
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
            let color: DoodleColor = self.currentColor
            let brush: DoodleBrush = self.currentBrush

            self.currentPaths?.append(contentsOf: paths)
            self.view?.displayNewDrawing(paths, color: color.uiColor, brush: brush)
            self.currentLine = DrawLine(
                paintColor: color,
                paintBrush: brush,
                frame: rect,
                paths: paths
            )
        }
    }
    
    func touchesMoved(_ touches: [UITouch]) {
        handleQueue.async { [weak self] in
            guard let self = self else { return }
            guard let line = self.currentLine else { return }

            let paths = self.updateLocationAndMakePaths(
                touches,
                previousTouch: self.currentTouch
            )

            self.currentPaths?.append(contentsOf: paths)
            self.view?.displayNewDrawing(
                paths,
                color: line.paintColor.uiColor,
                brush: line.paintBrush
            )
        }
    }
    
    func touchEnd() {
        handleQueue.async { [weak self] in
            guard let self = self else { return }
            guard let currentLine = self.currentLine else { return }
            self.currentTouch = nil

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
            self.currentTouch = nil
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

    private func updateLocationAndMakePaths(_ touches: [UITouch], previousTouch: UITouch? = nil) -> [DrawPath] {

        var touches = touches
        if let previousTouch = previousTouch {
            touches.insert(previousTouch, at: 0)
        }
        
        return pathMaker.makePaths(with: touches) { [weak self] touch, path in
            guard let self = self else { return }
            self.currentTouch = touch
            let location = path.location
            let radius = path.width / 2
            self.frameCalculator.setLocations([
                CGPoint(x: location.x - radius, y: location.y - radius),
                CGPoint(x: location.x + radius, y: location.y + radius)
            ])
        }
    }
}
