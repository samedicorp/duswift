// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 24/08/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Coercion
import Expressions
import Foundation

class CraftingHandler: LogEntryHandler {
    func handle(_ entry: LogEntry, processor: LogProcessor) {
        let message = entry.message
        if let range = message.range(of: "RecipeQueue:") {
            let string = String(message[range.lowerBound...])
            let decoded = processor.dataParser.parse(string)
            if let queue = decoded as? RecipeQueue {
                for status in queue.queue {
                    processor.register(recipe: status.recipe)
                }
            }
        }
    }
}
    
