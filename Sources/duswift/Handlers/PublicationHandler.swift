// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 20/08/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import duswift
import Expressions
import Foundation

class PublicationHandler: LogEntryHandler {
    let pattern = try! NSRegularExpression(pattern: #"constructId = (\d+).*?name = ([\w \[\]]+)"#)


    struct ConstructMatch: Constructable {
        var id = ""
        var name = ""
    }

    func handle(_ entry: LogEntry, processor: LogProcessor) {
        if entry.message.starts(with: "did receive ConstructInfo") {
            handleConstructInfo(entry, processor: processor)
        }
    }
    
    func handleConstructInfo(_ entry: LogEntry, processor: LogProcessor) {
        if let match: ConstructMatch = pattern.firstMatch(in: entry.message, capturing: [\.id: 1, \.name: 2]) {
            let name = match.name.trimmingCharacters(in: .whitespaces)
            let construct = Construct(id: Int(match.id)!, name: name, sort: name.lowercased(), entry: entry)
            processor.append(construct: construct)
        } else {
            print(entry)
        }
    }
}
