// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 20/08/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import duswift
import Foundation

let smallLog = URL(fileURLWithPath: "/Users/sam/Dropbox/Games/Dual Universe/Logs/log_2021-08-18_01h35m17s.txt")
let exampleLog = URL(fileURLWithPath: "/Users/sam/Developer/Projects/duswift/Sources/duswift/Resources/example-log.xml")
let bigLog = URL(fileURLWithPath: "/Users/sam/Dropbox/Games/Dual Universe/Logs/log_2021-08-17_18h51m44s.xml")

let name = bigLog.deletingPathExtension().lastPathComponent

print("Parsing file.")
let parser = LogParser(url: bigLog)

Task {
    for await entry in parser.entryStream() {
        print(entry.message)
    }
}
