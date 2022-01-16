//
//  RectCalculatorTests.swift
//  Doodles in SwiftUITests
//
//  Created by 倪僑德 on 2021/12/24.
//

import XCTest
@testable import Doodles_in_SwiftUI

class RectCalculatorTests: XCTestCase {
    
    var sut: RectCalculator!

    override func setUpWithError() throws {
        sut = RectCalculator()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testExample() throws {
        sut.setLocations([Seeds.midPoint, Seeds.minPoint])
        sut.setLocations([Seeds.maxPoint])
        XCTAssertEqual(sut.exportNecessaryRect(), Output.frame)
    }
}

extension RectCalculatorTests {
    
    enum Seeds {
        static var minPoint: CGPoint { CGPoint(x: 50, y: 100) }
        static var midPoint: CGPoint { CGPoint(x: 75, y: 150) }
        static var maxPoint: CGPoint { CGPoint(x: 150, y: 323) }
    }
    
    enum Output {
        static var frame: CGRect { CGRect(x: 50, y: 100, width: 100, height: 223) }
    }
}
