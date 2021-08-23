// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 20/08/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Coercion
import duswift
import Expressions
import Foundation

class MarketListHandler: LogEntryHandler {
    func handle(_ entry: LogEntry, processor: LogProcessor) {
        let message = entry.message
        if message.starts(with: "MarketList") {
            if let index = message.firstIndex(of: ":") {
                let string = String(message[message.index(after: index)...])
                let parser = LogDataParser()
                let decoded = parser.parse(string)
                if let object = decoded as? [String:Any], object[asString: "kind"] == "MarketList" {
                    handleMarketList(object)
                }
            }
        }
        
        func handleMarketList(_ list: [String:Any]) {
            if let markets = list["markets"] as? [[String:Any]] {
                for market in markets {
                    print(market[asString: "name"]!)
                    print(market)
                }
            }
        }
    }
}
    
