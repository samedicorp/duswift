// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 05/05/2021.
//  All code (c) 2021 - present day, Elegant Chaos.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import XCTest
import XCTestExtensions
import ElegantStrings
import Files

@testable import duswift

let bigLog = URL(fileURLWithPath: "/Users/sam/Dropbox/Games/Dual Universe/Logs/log_2021-08-17_18h51m44s.xml")
let exampleLog = URL(fileURLWithPath: "/Users/sam/Developer/Projects/duswift/Sources/duswift/Resources/example-log.xml")
let smallLog = URL(fileURLWithPath: "/Users/sam/Dropbox/Games/Dual Universe/Logs/log_2021-08-17_18h51m44s.xml")

final class duswiftTests: XCTestCase {
    func testDataParser() {
        let sample = "MarketInfo:[marketId = 1662, relativeLocation = RelativeLocation:[constructId = 0, position = Vec3:[-13240359.185984, 55770780.524610, 523150.759589], rotation = Quat:[0.000394, -0.065151, -0.651803, 0.755584]]]"
        let parser = LogDataParser()
        let parsed = parser.parse(sample)
        print(parsed)
    }
    
    func testPropertiesParser() {
        let parser = LogDataParser()
        
        XCTAssertEqual(parser.parseValue("1") as? Int, 1)
        XCTAssertEqual(parser.parseValue("Test") as? String, "Test")
        
        let value = parser.parseValue("Class:[name = Blah, id = 123]") as! [String:Any]
        print(value)
        XCTAssertEqual(value["kind"] as? String, "Class")
        XCTAssertEqual(value["name"] as? String, "Blah")
        XCTAssertEqual(value["id"] as? Int, 123)
    }
}
