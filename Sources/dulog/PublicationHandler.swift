// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 20/08/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import duswift
import Expressions
import Foundation

class PublicationHandler: LogEntryHandler {
    let pattern = try! NSRegularExpression(pattern: #"constructId = (\d+).*?name = ([\w \[\]]+)"#)

    struct Construct {
        let id: Int
        let name: String
        let sort: String
        let entry: LogEntry
    }
    
    var constructs: [Int:Construct] = [:]

    struct ConstructMatch: Constructable {
        var id = ""
        var name = ""
    }

    func handle(_ entry: LogEntry) {
        if entry.message.starts(with: "did receive ConstructInfo") {
            handleConstructInfo(entry)
        }
    }
    
    func handleConstructInfo(_ entry: LogEntry) {
        if let match: ConstructMatch = pattern.firstMatch(in: entry.message, capturing: [\.id: 1, \.name: 2]) {
            if let id = Int(match.id) {
                if constructs[id] == nil {
                    let name = match.name.trimmingCharacters(in: .whitespaces)
                    constructs[id] = Construct(id: id, name: name, sort: name.lowercased(), entry: entry)
                }
            }
        } else {
            print(entry)
        }
    }
    
    func finish() {
        if constructs.count > 0 {
            print("Found constructs:")
            for construct in constructs.values.sorted(by: { $0.sort < $1.sort  }) {
                print("\(construct.name) (\(construct.id)).")
            }
        }
    }
}
