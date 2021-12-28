//
//  DrawingView.swift
//  Doodles in SwiftUI
//
//  Created by 倪僑德 on 2021/12/26.
//

import UIKit
import Combine

protocol CanvasDisplayLogic: AnyObject {
    func displayNewDrawing(_ paths: [DrawPath], color: UIColor, brush: DoodleBrush)
    func displayDoodle(_ doodle: DrawDoodle)
}

final class CanvasView: UIControl {
    var paintColor = CurrentValueSubject<DoodleColor, Never>(.blue)
    var paintBrush = CurrentValueSubject<DoodleBrush, Never>(.pencil)
    private var cancellables = Set<AnyCancellable>()
    
    private var controller: CanvasBusinessLogic?
    private let painter = Painter()
    private var drawingImage: UIImage?
    private var backgroundImage: UIImage?
    private let saveButton: UIButton = UIButton(type: .close)
    
    init(store: DoodleStorageLogic){
        super.init(frame: .zero)
        
        let controller = CanvasController(store: store)
        controller.view = self
        self.controller = controller
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        drawingImage?.draw(in: rect)
        backgroundImage?.draw(in: rect)
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        controller?.makeDoodle()
    }
    
    //MARK: - Touch event
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touches = getTouches(touches, with: event) else { return }
        controller?.startTouching(touches, in: bounds)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touches = getTouches(touches, with: event) else { return }
        controller?.touchesMoved(touches)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        controller?.touchEnd()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        controller?.touchEnd()
    }
}

// MARK: - Canvas DisplayLogic
extension CanvasView: CanvasDisplayLogic {
    func displayNewDrawing(_ paths: [DrawPath], color: UIColor, brush: DoodleBrush) {
        DispatchQueue.main.async {
            self.drawingImage = self.painter.draw(
                paths,
                in: self.bounds,
                canvasRect: self.bounds,
                backgroundImage: self.drawingImage,
                color: color,
                brush: brush
            )
            self.setNeedsDisplay()
        }
    }
    
    func displayDoodle(_ doodle: DrawDoodle) {
////         For Debug
//        DispatchQueue.main.async {
//            self.backgroundImage = UIGraphicsImageRenderer(size: self.bounds.size).image { context in
//                UIColor.yellow.withAlphaComponent(0.5).setFill()
//                context.fill(doodle.frame)
//             }
//
//            print(self.bounds)
//            print(doodle.frame)
//            doodle.lines.forEach { print($0.frame) }
//            doodle.lines.forEach { line in
//                let frame = CGRect(
//                    origin: doodle.frame.origin + line.frame.origin,
//                    size: self.bounds.size
//                )
//                self.drawingImage = self.painter.draw(
//                    line.paths,
//                    in: frame,
//                    pathOffset: frame.origin,
//                    canvasRect: self.bounds,
//                    backgroundImage: self.drawingImage,
//                    color: .blue,
//                    brush: line.paintBrush
//                )
//            }
//            self.setNeedsDisplay()
//        }
    }
}

// MARK: - Private functions
extension CanvasView {
    
    private func setUp() {
        paintColor
            .combineLatest(paintBrush)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] event in
                guard let self = self else { return }
                self.controller?.updateSetting(
                    color: event.0,
                    brush: event.1
                )
            })
            .store(in: &cancellables)
        paintColor.send(.blue)
        
        backgroundColor = .clear
        saveButton
            .add(to: self)
            .anchor(\.topAnchor, to: topAnchor, constant: 30)
            .anchor(\.trailingAnchor, to: trailingAnchor, constant: -30)
            .addTarget(self, action: #selector(saveCurrentResult), for: .touchUpInside)
    }
    
    private func getTouches(_ touches: Set<UITouch>, with event: UIEvent?) -> [UITouch]? {
        guard let touch = touches.first else { return nil }
        if let touches = event?.coalescedTouches(for: touch) {
            return Array(touches)
        } else {
            return [touch]
        }
    }
    
    @objc
    private func saveCurrentResult() {
        controller?.makeDoodle()
    }
}
