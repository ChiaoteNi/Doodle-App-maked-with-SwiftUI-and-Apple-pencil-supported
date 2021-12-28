//
//  DoodleColor.swift
//  Doodles in SwiftUI
//
//  Created by 倪僑德 on 2021/12/25.
//

import UIKit
import SwiftUI

enum DoodleColor: CaseIterable {
    case black
    case red
    case blue
    case green
    case orange
    case purple
    case yellow
    
    var uiColor: UIColor {
        switch self {
        case .black:    return .black
        case .red:      return .red
        case .blue:     return .blue
        case .green:    return .green
        case .orange:   return .orange
        case .purple:   return .purple
        case .yellow:   return .yellow
        }
    }
    
    var color: Color { Color(uiColor) }
}

