//
//  DoodleRepresentView.swift
//  Doodles in SwiftUI
//
//  Created by 倪僑德 on 2021/12/27.
//

import SwiftUI

struct DoodleRepresentView: UIViewRepresentable {
    
    @State var doodle: DrawDoodle
    let color: DoodleColor
    let brush: DoodleBrush
    let brushSizeDiff: CGFloat
    
    class Coordinator: NSObject {
        @Binding var doodle: DrawDoodle

        init(doodle: Binding<DrawDoodle>) {
            _doodle = doodle
        }
    }
    
    func makeCoordinator() -> DoodleRepresentView.Coordinator {
        Coordinator(doodle: $doodle)
    }
    
    func makeUIView(context: Context) -> DoodleDisplayView {
        let view = DoodleDisplayView(doodle: doodle)
        view.frame.size = doodle.frame.size
        return view
    }
    
    func updateUIView(_ uiView: DoodleDisplayView, context: Context) {
        uiView.lineColor.send(color)
        uiView.patinBrush.send(brush)
        uiView.brushSizeDiff.send(brushSizeDiff)
    }
}
