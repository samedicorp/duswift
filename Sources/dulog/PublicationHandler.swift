// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 20/08/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import duswift
import Expressions
import Foundation

struct PublicationHandler: LogEntryHandler {
    func handle(_ entry: LogEntry) {
        if entry.message.starts(with: "did receive ConstructInfo") {
            handleConstructInfo(entry)
        }
    }
    
    func handleConstructInfo(_ entry: LogEntry) {
        print(entry)
    }
}
