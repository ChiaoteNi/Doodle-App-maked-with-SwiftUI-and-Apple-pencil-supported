//
//  CanvasRepresentView.swift
//  Doodles in SwiftUI
//
//  Created by 倪僑德 on 2021/12/25.
//

import SwiftUI
import Combine

final class CanvasRepresentView: UIViewRepresentable {
    
    private final class DoodleStore: DoodleStorageLogic {
        @Published var doodle: DrawDoodle?
        var subscriptions: Set<AnyCancellable> = Set()
        
        init(doodle: DrawDoodle?) {
            self.doodle = doodle
        }
        
        func updateDoodle(_ doodle: DrawDoodle) {
            self.doodle = doodle
        }
        
        func clearDoodle() {
            self.doodle = nil
        }
    }
    
    @Binding var isCanvasDisplay: Bool
    @State var doodle: DrawDoodle?
    let color: DoodleColor
    let brush: DoodleBrush
    
    private var doodleUpdateAction: ((DrawDoodle?) -> Void)?
    
    init(
        doodle: DrawDoodle?,
        color: DoodleColor,
        brush: DoodleBrush,
        isCanvasDisplay: Binding<Bool>
    ) {
        self.doodle = doodle
        self.color = color
        self.brush = brush
        _isCanvasDisplay = isCanvasDisplay
    }
    
    @discardableResult
    func onChanged(_ action: @escaping (DrawDoodle?) -> Void) -> Self {
        doodleUpdateAction = action
        return self
    }
    
    // MARK: - UIViewRepresentable functions
    
    func makeUIView(context: Context) -> CanvasView {
        let store = DoodleStore(doodle: doodle)
        store.$doodle
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newDoodle in
                self?.doodleUpdateAction?(newDoodle)
                self?.isCanvasDisplay = false
            }
            .store(in: &store.subscriptions)
        return CanvasView(store: store)
    }
    
    func updateUIView(_ uiView: CanvasView, context: Context) {
        uiView.paintColor.send(color)
        uiView.paintBrush.send(brush)
    }
}
