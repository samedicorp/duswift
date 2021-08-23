// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 20/08/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import duswift
import Expressions
import Foundation

struct LoginHandler: LogEntryHandler {
    let pattern = try! NSRegularExpression(pattern: "playerId = (\\d+), username = (\\w+)")

    struct Login: Constructable {
        var name = ""
        var id = ""
    }

    func handle(_ entry: LogEntry, processor: LogProcessor) {
        if let match: Login = pattern.firstMatch(in: entry.message, capturing: [\.name: 2, \.id: 1]) {
            print("Login \(match.name) (\(match.id)).")
        }
    }
}
