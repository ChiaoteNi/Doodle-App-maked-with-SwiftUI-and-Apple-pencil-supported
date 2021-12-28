//
//  DoodleDisplayView.swift
//  Doodles in SwiftUI
//
//  Created by 倪僑德 on 2021/12/26.
//

import UIKit
import Combine
import SwiftUI

final class DoodleDisplayView: UIView {
    var newColorTrigger = CurrentValueSubject<DoodleColor?, Never>(nil)
    var newBrushTrigger = CurrentValueSubject<DoodleBrush?, Never>(nil)
    private var cancellables = Set<AnyCancellable>()
    
    let doodle: DrawDoodle?
    private let painter = Painter()
    private var displayDoodle: UIImage?
    
    init(doodle: DrawDoodle){
        self.doodle = doodle
        super.init(frame: .zero)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        displayDoodle?.draw(in: rect)
    }
    
    private func setUp() {
        backgroundColor = .clear
        newColorTrigger
            .combineLatest(newBrushTrigger)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] event in
                guard let self = self,
                      let doodle = self.doodle else { return }
                self.displayDoodle = self.makeDoodle(
                    with: doodle.lines,
                    origin: doodle.frame.origin,
                    color: event.0,
                    brush: event.1
                )
                self.setNeedsDisplay()
            })
            .store(in: &cancellables)
    }
    
    private func makeDoodle(
        with lines: [DrawLine],
        origin: CGPoint,
        color: DoodleColor?,
        brush: DoodleBrush?
    ) -> UIImage {
        var doodle: UIImage = UIImage()
        
        lines.forEach { line in
            doodle = painter.draw(
                line.paths,
                in: line.frame,
                pathOffset: line.frame.origin,
                canvasRect: bounds,
                backgroundImage: doodle,
                color: color?.uiColor ?? line.paintColor.uiColor,
                brush: brush ?? line.paintBrush
            )
        }
        return doodle
    }
}


