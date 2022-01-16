//
//  BrushSizeSlider.swift
//  Doodles in SwiftUI
//
//  Created by 倪僑德 on 2021/12/28.
//

import SwiftUI

struct BrushSizeSlider: View {
    @Binding var brushSize: CGFloat
    
    var body: some View {
        Slider(value: $brushSize, in: -5...15)
            .frame(width: 80, height: 30)
    }
}
