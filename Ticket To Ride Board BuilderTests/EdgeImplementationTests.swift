import XCTest
@testable import Ticket_To_Ride_Board_Builder

class EdgeImplementationTests: XCTestCase {
    
    func testSelfEquality() {
        let edge1 = Edge(from: "sourceOne", to: "sourceTwo", withLabel: "labelOne")
        XCTAssert(edge1 == edge1)
    }
    
    func testEquality() {
        let edge1 = Edge(from: "sourceOne", to: "sourceTwo", withLabel: "labelOne")
        let edge2 = Edge(from: "sourceOne", to: "sourceTwo", withLabel: "labelOne")
        XCTAssert(edge1 == edge2)
    }
    
    func testBasicInequality() {
        
        let edge1 = Edge(from: "sourceOne", to: "sourceTwo", withLabel: "labelOne")
        let edge2 = Edge(from: "sourceTwo", to: "sourceThree", withLabel: "labelTwo")
        XCTAssert(edge1 != edge2)
    }
    
    func testSrcInequality() {
        let edge1 = Edge(from: "sourceOne", to: "sourceTwo", withLabel: "labelOne")
        let edge2 = Edge(from: "sourceThree", to: "sourceTwo", withLabel: "labelOne")
        XCTAssert(edge1 != edge2)
    }
    
    func testDstInequality() {
        let edge1 = Edge(from: "sourceOne", to: "sourceTwo", withLabel: "labelOne")
        let edge2 = Edge(from: "sourceOne", to: "sourceThree", withLabel: "labelOne")
        XCTAssert(edge1 != edge2)
    }
    
    func testLabelInequality() {
        let edge1 = Edge(from: "sourceOne", to: "sourceTwo", withLabel: "labelOne")
        let edge2 = Edge(from: "sourceOne", to: "sourceTwo", withLabel: "labelTwo")
        XCTAssert(edge1 != edge2)
    }
    
    func testFlippedSrcDstInequality() {
        let edge1 = Edge(from: "sourceOne", to: "sourceTwo", withLabel: "labelOne")
        let edge2 = Edge(from: "sourceTwo", to: "sourceOne", withLabel: "labelOne")
        XCTAssert(edge1 != edge2)
    }
    
    func testIntEquality() {
        let edge1 = Edge(from: 1, to: 2, withLabel: 3)
        let edge2 = Edge(from: 1, to: 2, withLabel: 3)
        XCTAssert(edge1 == edge2)
    }
    
    func testIntInequality() {
        let edge1 = Edge(from: 1, to: 2, withLabel: 3)
        let edge2 = Edge(from: 2, to: 1, withLabel: 3)
        XCTAssert(edge1 != edge2)
    }
    
    func testMixedEquality() {
        let edge1 = Edge(from: 1, to: 2, withLabel: "label")
        let edge2 = Edge(from: 1, to: 2, withLabel: "label")
        XCTAssert(edge1 == edge2)
    }
    
    func testMixedInequality() {
        let edge1 = Edge(from: 1, to: 2, withLabel: "label")
        let edge2 = Edge(from: 1, to: 2, withLabel: "two")
        let edge3 = Edge(from: 2, to: 2, withLabel: "label")
        XCTAssert(edge1 != edge2)
        XCTAssert(edge2 != edge3)
    }
    
}
