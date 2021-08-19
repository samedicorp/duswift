//
//  File.swift
//  File
//
//  Created by Sam Deane on 19/08/2021.
//

import duswift
import Files
import Foundation

let smallLog = URL(fileURLWithPath: "/Users/sam/Dropbox/Games/Dual Universe/Logs/log_2021-08-18_01h35m17s.txt")
let exampleLog = URL(fileURLWithPath: "/Users/sam/Developer/Projects/duswift/Sources/duswift/Resources/example-log.xml")
let bigLog = URL(fileURLWithPath: "/Users/sam/Dropbox/Games/Dual Universe/Logs/log_2021-08-17_18h51m44s.xml")

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
