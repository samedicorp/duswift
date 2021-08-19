// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 05/05/2021.
//  All code (c) 2021 - present day, Elegant Chaos.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import XCTest
import XCTestExtensions

@testable import duswift

let bigLog = URL(fileURLWithPath: "/Users/sam/Dropbox/Games/Dual Universe/Logs/log_2021-08-17_18h51m44s.xml")
let exampleLog = URL(fileURLWithPath: "/Users/sam/Developer/Projects/duswift/Sources/duswift/Resources/example-log.xml")
let smallLog = URL(fileURLWithPath: "/Users/sam/Dropbox/Games/Dual Universe/Logs/log_2021-08-17_18h51m44s.xml")

final class duswiftTests: XCTestCase {
    func testLogs() {
        
        let parser = LogParser()
        let log = parser.parse(url: exampleLog)
        
        for entry in log.entries {
            print(entry.message)
        }
    }
    
    func testClasses() {
        
        let parser = LogParser()
        let log = parser.parse(url: bigLog)
        
        var classes = Set(log.entries.map { $0.`class` })
        classes.formUnion(knownClasses)
        
        print(classes.sorted().joined(separator: "\",\n\""))
    }

}
