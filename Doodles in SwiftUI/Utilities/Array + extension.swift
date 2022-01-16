//
//  Array + extension.swift
//  Doodles in SwiftUI
//
//  Created by Chiaote Ni on 2022/1/15.
//

import Foundation

extension Array {
    typealias E = Element

    subscript(safe index: Int) -> E? {
        guard index >= 0, index < count else { return nil }
        let element = self[index]
        return element
    }
}
