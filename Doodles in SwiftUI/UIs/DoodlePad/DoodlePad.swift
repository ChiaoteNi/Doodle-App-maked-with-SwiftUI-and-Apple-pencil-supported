//
//  DoodlePad.swift
//  Doodle in SwiftUI
//
//  Created by 倪僑德 on 2021/12/25.
//  Copyright (c) 2021 iOS@Taipei in iPlayground 2020. All rights reserved.
//
//  This file was generated by iOS@Taipei's Clean Architecture Xcode Templates, which
//  is goaled to help you apply clean architecture to your iOS projects,
//

import SwiftUI
import Combine

struct DoodlePad: View {
    
    struct BackgroundView: View {
        @Binding var isCanvasDisplay: Bool
        var body: some View {
            Color.white
                .onTapGesture { isCanvasDisplay = true }
        }
    }
    
    @Store var store: DoodlePadStore
    var interactor: DoodlePadBusinessLogic
    
    @State var color: DoodleColor = .red
    @State var brush: DoodleBrush = .marker
    @State var brushSizeDiff: CGFloat = 0
    @State var isCanvasDisplay: Bool = false
    
    var subscriptions: Set<AnyCancellable> = Set()
    
    init() {
        let interactor: DoodlePadInteractor = .init()
        let store: DoodlePadStore = .init()
        interactor.stateStore = store
        
        self.interactor = interactor
        _store = Store(wrappedValue: store)
    }
    
    var body: some View {
        VStack {
            ZStack {
                BackgroundView(isCanvasDisplay: $isCanvasDisplay)
                ForEach(store.doodles) { doodle in
                    DoodleView(store: DoodleStore(
                        doodle: doodle,
                        color: $color,
                        brush: $brush,
                        brushSizeDiff: $brushSizeDiff
                    ))
                }
                makeCanvasIfNeeded()
            }
            ZStack {
                Color.white
                HStack {
                    Spacer()
                    ColorPickerView(pickedColor: $color)
                    Spacer()
                    BrushPickerView(pickedBrush: $brush)
                    Spacer()
                    BrushSizeSlider(brushSize: $brushSizeDiff)
                    Spacer()
                }
            }
            .frame(height: 50, alignment: .center)
        }
    }
}

// MARK: - Private functions.
extension DoodlePad {
    @ViewBuilder
    func makeCanvasIfNeeded() -> some View {
        if isCanvasDisplay {
            CanvasRepresentView(
                doodle: nil,
                color: color,
                brush: brush,
                isCanvasDisplay: $isCanvasDisplay
            )
                .onChanged { doodle in
                    guard let doodle = doodle else { return }
                    store.add(doodle)
                }
                .transition(.move(edge: .bottom))
                .animation(.easeInOut(duration: 0.5))
                .zIndex(10)
        } else {
            EmptyView()
        }
    }
} 

// MARK: - Constants
extension DoodlePad {
    //...
} 

// MARK: - Previews
struct DoodlePad_Previews: PreviewProvider {
    static var previews: some View {
        DoodlePad()
    }
}

