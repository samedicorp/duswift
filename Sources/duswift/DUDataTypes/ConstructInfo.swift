// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 23/08/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

public struct Construct: DUDataType, Codable {
    public init(id: Int, name: String, sort: String, entry: LogEntry) {
        self.id = id
        self.name = name
        self.sort = sort
        self.entry = entry
    }
    
    public let id: Int
    public let name: String
    public let sort: String
    public let entry: LogEntry
    
    public init?(duData: [String : Any]) {
        return nil
    }
}
