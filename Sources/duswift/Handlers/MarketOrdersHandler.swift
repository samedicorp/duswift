// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 23/08/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Coercion
import Expressions
import Foundation

class MarketOrdersHandler: LogEntryHandler {
    func handle(_ entry: LogEntry, processor: LogProcessor) {
        let message = entry.message
        if message.starts(with: "onUpdateMarketItemOrders") {
            if let index = message.firstIndex(of: ":") {
                let string = String(message[message.index(after: index)...])
                let decoded = processor.dataParser.parse(string)
                if let orders = decoded as? MarketOrders {
                    for order in orders.orders {
                        if order.ownerName == "Elegant Chaos" {
                            print(order)
                        }
                        processor.register(order: order)
                    }
                }
            }
        }
    }
}
