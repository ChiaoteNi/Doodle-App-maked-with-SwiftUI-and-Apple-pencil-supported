//
//  DoodleStore.swift
//  Doodles in SwiftUI
//
//  Created by 倪僑德 on 2021/12/27.
//  Copyright (c) 2021 iOS@Taipei in iPlayground 2020. All rights reserved.
//
//  This file was generated by iOS@Taipei's Clean Architecture Xcode Templates, which
//  is goaled to help you apply clean architecture to your iOS projects,

import Foundation
import SwiftUI

protocol DoodleVMSpec: AnyObservableObject {
    var doodle: DrawDoodle { get }
    var color: DoodleColor { get }
    var brush: DoodleBrush { get }
}

protocol DoodleStateStoreLogic {
    func update(_ doodle: DrawDoodle)
}

final class DoodleStore: ObservableObject, DoodleStateStoreLogic, DoodleVMSpec {
    
    // MARK: DoodleStoreSpec Properties
    
    @Published var doodle: DrawDoodle
    @Binding var color: DoodleColor
    @Binding var brush: DoodleBrush
    
    // MARK: DoodleStatusLogic Properties
    
    init(
        doodle: DrawDoodle,
        color: Binding<DoodleColor>,
        brush: Binding<DoodleBrush>
    ) {
        self.doodle = doodle
        _color = color
        _brush = brush
    }
        
    // MARK: Private properties
    func update(_ doodle: DrawDoodle) {
        self.doodle = doodle
    }
}