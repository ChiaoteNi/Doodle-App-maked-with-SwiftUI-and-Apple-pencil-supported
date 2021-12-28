//
//  ColorPickerView.swift
//  Doodles in SwiftUI
//
//  Created by 倪僑德 on 2021/12/25.
//

import SwiftUI

struct ColorPickerView: View {
    @Binding var pickedColor: DoodleColor
    
    let diameter: CGFloat = 30
    
    var body: some View {
        HStack {
            ForEach(DoodleColor.allCases, id: \.self) { item in
                let isPickedItem = pickedColor == item
                Circle()
                    .foregroundColor(item.color)
                    .frame(width: diameter, height: diameter)
                    .offset(
                        x: isPickedItem ? 2 : 0,
                        y: isPickedItem ? 2 : 0
                    )
                    .onTapGesture { pickedColor = item }
                    .shadow(
                        color: Color.black.opacity(0.5),
                        radius: isPickedItem ? 0 : 2,
                        x: isPickedItem ? 0 : 2,
                        y: isPickedItem ? 0 : 2
                    )
            }
        }
        .frame(height: diameter * 3)
    }
}

struct ColorPickerView_Previews: PreviewProvider {
    @State static var color: DoodleColor = .red
    
    static var previews: some View {
        ColorPickerView(pickedColor: $color)
    }
}
