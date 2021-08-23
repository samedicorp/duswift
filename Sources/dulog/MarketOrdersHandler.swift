// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 23/08/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Coercion
import duswift
import Expressions
import Foundation

class MarketOrdersHandler: LogEntryHandler {
    func handle(_ entry: LogEntry) {
        let message = entry.message
        if message.starts(with: "onUpdateMarketItemOrders") {
            if let index = message.firstIndex(of: ":") {
                let string = String(message[message.index(after: index)...])
                let parser = LogDataParser()
                let decoded = parser.parse(string)
                if let object = decoded as? [String:Any], object[asString: "kind"] == "MarketOrders" {
                    handleMarketOrders(object)
                } else {
                    print(decoded)
                }
            }
        } else {
            print(entry)
        }
    }
    
    func handleMarketOrders(_ list: [String:Any]) {
        if let markets = list["orders"] as? [[String:Any]] {
            for market in markets {
                print(market[asString: "ownerName"]!)
                print(market)
            }
        }
    }
}
