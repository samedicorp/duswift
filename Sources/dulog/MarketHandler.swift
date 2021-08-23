// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 20/08/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import duswift
import Expressions
import Foundation

class MarketHandler: LogEntryHandler {
    func handle(_ entry: LogEntry) {
        let message = entry.message
        if message.starts(with: "MarketList") {
            if let index = message.firstIndex(of: ":") {
                let string = String(message[message.index(after: index)...])
                let parser = LogDataParser()
                let decoded = parser.parse(string)
                print(decoded)
            }
            print(entry)
        }
    }
}
