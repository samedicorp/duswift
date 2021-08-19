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

    func testRelog() {
        let name = bigLog.deletingPathExtension().lastPathComponent
        let bigJSON = ThrowingManager.file(for: bigLog.deletingLastPathComponent().appendingPathComponent(name).appendingPathExtension("json"))

        if !bigJSON.exists {
            print("Converting file.")
            let parser = LogParser()
            let log = parser.parse(url: bigLog)
            
            print("\(log.entries.count) entries.")
            
            print("Encoding file.")
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            let data = try! encoder.encode(log)
            try! data.write(to: bigJSON.url)
        } else {
            print("Decoding file.")
            let decoder = JSONDecoder()
            let log = try! decoder.decode(LogFile.self, from: try! Data(contentsOf: bigJSON.url))
            
            print("\(log.entries.count) entries.")
            print(log.entries.map { $0.message })
        }

        print("blah")

    }
    
    func testAsync() {
        let re = try! NSRegularExpression(pattern: "<(.*?)>(.*?)</\\1>", options: .allowCommentsAndWhitespace)

        Task {
            do {
                for try await line in bigLog.lines {
                    var range = NSRange(location: 0, length: line.count)
                    if line == "<record>" {
                        print("record start")
                    } else if line == "</record>" {
                        print("record end")
                    } else if let match = re.firstMatch(in: line, options: [], range: range) {
                        let lineString = String(line)
                        let nameRange = match.range(at: 1)
                        let start = lineString.index(lineString.startIndex, offsetBy: nameRange.location)
                        let end = lineString.index(lineString.startIndex, offsetBy: nameRange.location + nameRange.length)
                        let name = lineString[start ..< end]
                        print(name)
                        print(match.range(at: 2))
                    }
                    print(line)
                }
            } catch {
                
            }
        }
    }
}
