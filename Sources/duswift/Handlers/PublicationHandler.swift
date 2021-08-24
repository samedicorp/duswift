// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 20/08/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Expressions
import Foundation

class PublicationHandler: LogEntryHandler {
    let pattern = try! NSRegularExpression(pattern: #"constructId = (\d+).*?name = ([\w \[\]]+)"#)
    
    
    struct ConstructMatch: Constructable {
        var id = ""
        var name = ""
    }
    
    func handle(_ entry: LogEntry, processor: LogProcessor) {
        let message = entry.message
        if message.starts(with: "did receive ConstructInfo") {
            let string = String(message[message.index(message.startIndex, offsetBy: 12)...])
            let decoded = processor.dataParser.parse(string)
            if let construct = decoded as? ConstructInfo {
                processor.register(construct: construct)
            }
        }
    }
}

