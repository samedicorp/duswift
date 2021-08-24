// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 20/08/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Coercion
import Expressions
import Foundation

class MarketListHandler: LogEntryHandler {
    func handle(_ entry: LogEntry, processor: LogProcessor) {
        let message = entry.message
        if message.starts(with: "MarketList") {
            if let index = message.firstIndex(of: ":") {
                let string = String(message[message.index(after: index)...])
                let decoded = processor.dataParser.parse(string)
                if let markets = decoded as? MarketList {
                    for market in markets.markets {
                        processor.register(market: market)
                    }
                }
            }
        }
    }
}
    
