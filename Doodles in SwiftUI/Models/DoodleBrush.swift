//
//  DoodleBrush.swift
//  Doodles in SwiftUI
//
//  Created by 倪僑德 on 2021/12/25.
//

import Foundation
import UIKit

enum DoodleBrush: CaseIterable {
    case pencil
    case marker
    
    var name: String {
        switch self {
        case .marker: return "馬克筆"
        case .pencil: return "鉛筆"
        }
    }

    var brushImage: UIImage? {
        switch self {
        case .marker: return nil
        case .pencil: return UIImage(named: "Pencil")
        }
    }
    
    func getBrushTintColor(with color: UIColor) -> UIColor {
        guard let image = brushImage else { return color }
        let tintedImage = UIGraphicsImageRenderer(size: image.size).image { _ in
            color.set()
            image.draw(at: .zero)
        }
        return UIColor(patternImage: tintedImage)
    }
}
