//
//  BrushPickerView.swift
//  Doodles in SwiftUI
//
//  Created by 倪僑德 on 2021/12/25.
//

import SwiftUI

struct BrushPickerView: View {
    @Binding var pickedBrush: DoodleBrush
    
    let diameter: CGFloat = 30
    
    var body: some View {
        HStack {
            ForEach(DoodleBrush.allCases, id: \.self) { item in
                let isPickedItem = pickedBrush == item
                VStack {
                    makeIcon(for: item)
                        .frame(width: diameter, height: diameter)
                        .mask(Circle().frame(width: diameter, height: diameter))
                    Text(item.name)
                        .foregroundColor(.black)
                }
                .offset(
                    x: isPickedItem ? 2 : 0,
                    y: isPickedItem ? 2 : 0
                )
                .onTapGesture { pickedBrush = item }
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

// MARK: - Private functions
extension BrushPickerView {

    @ViewBuilder
    private func makeIcon(for brush: DoodleBrush) -> some View {
        switch brush {
        case .pencil:
            if let image = brush.brushImage {
                Image(uiImage: image)
            } else {
                EmptyView()
            }
        case .marker:
            Color(brush.getBrushTintColor(with: .darkGray))
        }
    }
}


//struct BrushPicker_Previews: PreviewProvider {
//    static var previews: some View {
//        BrushPicker()
//    }
//}
