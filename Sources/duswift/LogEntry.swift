// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 20/08/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

public struct LogEntry: Codable {
    static let formatter = ISO8601DateFormatter()
    public let date: Date
    public let millis: Int
    public let sequence: Int
    public let logger: String
    public let level: String
    public let `class`: String
    public let method: String
    public let thread: Int
    public let message: String
    
    init(_ values: [String:String]) {
        date = Self.formatter.date(from: values["date"]!)!
        millis = values[asInt: "millis"] ?? Int(0)
        sequence = 0
        logger = values["logger"] ?? ""
        level = values["level"] ?? ""
        `class` = values["class"] ?? ""
        method = values["method"] ?? ""
        thread = 1
        message = values["message"] ?? ""
    }
}
