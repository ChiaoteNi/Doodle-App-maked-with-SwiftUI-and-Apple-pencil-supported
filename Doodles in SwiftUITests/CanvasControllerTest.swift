//
//  CanvasControllerTest.swift
//  Doodles in SwiftUITests
//
//  Created by 倪僑德 on 2021/12/27.
//

import XCTest
@testable import Doodles_in_SwiftUI

class CanvasControllerTest: XCTestCase {

    private var sut: CanvasController!
    
    override func setUpWithError() throws {
        sut = CanvasController()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testExample() throws {
        let spy = StoreSpy()
        sut.store = spy
        spy.doodleDidUpdate = { doodle in
            XCTAssertEqual(doodle?.frame, Output.doodleFrame)
            XCTAssertEqual(doodle?.lines.first?.frame, Output.fistLineFrame)
        }
        
        sut.startTouching([Seeds.midTouch], in: Seeds.frame)
        sut.touchesMoved([Seeds.maxTouch])
        sut.touchesMoved([Seeds.minTouch])
        sut.touchEnd()
        
        sut.startTouching([Seeds.midTouch2], in: Seeds.frame)
        sut.touchesMoved([Seeds.maxTouch2])
        sut.touchesMoved([Seeds.minTouch2])
        sut.touchEnd()
        
        sut.makeDoodle()
    }
}

extension CanvasControllerTest {
    
    class StoreSpy: DoodleStorageLogic {
        var doodle: DrawDoodle?
        var doodleDidUpdate: ((_ doodle: DrawDoodle?) -> Void)?
        
        func updateDoodle(_ doodle: DrawDoodle) {
            self.doodle = doodle
            doodleDidUpdate?(doodle)
        }
        
        func clearDoodle() {
            doodle = nil
            doodleDidUpdate?(nil)
        }
    }
    
    class MockTouch: UITouch {
        let point: CGPoint
        
        init(with point: CGPoint) {
            self.point = point
        }
        
        override func location(in view: UIView?) -> CGPoint {
            point
        }
        
        override func previousLocation(in view: UIView?) -> CGPoint {
            point
        }
    }
    
    enum Seeds {
        static var minPoint: CGPoint { CGPoint(x: 50, y: 100) }
        static var midPoint: CGPoint { CGPoint(x: 75, y: 150) }
        static var maxPoint: CGPoint { CGPoint(x: 150, y: 350) }
        
        static var minPoint2: CGPoint { CGPoint(x: 170, y: 50) }
        static var midPoint2: CGPoint { CGPoint(x: 120, y: 170) }
        static var maxPoint2: CGPoint { CGPoint(x: 30, y: 200) }
        
        static var midTouch: MockTouch { MockTouch(with: midPoint) }
        static var minTouch: MockTouch { MockTouch(with: minPoint) }
        static var maxTouch: MockTouch { MockTouch(with: maxPoint) }
        
        static var midTouch2: MockTouch { MockTouch(with: midPoint2) }
        static var minTouch2: MockTouch { MockTouch(with: minPoint2) }
        static var maxTouch2: MockTouch { MockTouch(with: maxPoint2) }
        
        static var frame: CGRect { CGRect(x: 0, y: 0, width: 600, height: 600) }
    }
    
    enum Output {
        static var fistLineFrame: CGRect { CGRect(x: 20, y: 50, width: 100, height: 250) }
        static var doodleFrame: CGRect { CGRect(x: 30, y: 50, width: 140, height: 300) }
    }
}
