// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 23/08/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

public protocol LogEntryHandler {
    func handle(_ entry: LogEntry, processor: LogProcessor)
    func finish(processor: LogProcessor)
}

extension LogEntryHandler {
    func finish(processor: LogProcessor) {
    }
}
