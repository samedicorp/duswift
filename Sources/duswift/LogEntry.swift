// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 20/08/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

public struct LogEntry: Codable {
    public enum Level: String, Codable {
        case unknown
        case debug
        case info
        case warning
        case error

        init(_ string: String?) {
            self = Self.level(string)
        }

        static func level(_ string: String?) -> Level {
            if let string = string?.lowercased() {
                if let level = Level(rawValue: string) {
                    return level
                } else {
                    print("Unknown level \(string)")
                }
            } else {
                print("Missing level")
            }
            
            return .unknown
        }
    }
    
    static let formatter = ISO8601DateFormatter()
    public let date: Date
    public let millis: Int
    public let sequence: Int
    public let logger: String
    public let level: Level
    public let `class`: String
    public let method: String
    public let thread: Int
    public let message: String
    
    init(_ values: [String:String]) {
        date = Self.formatter.date(from: values["date"]!)!
        millis = values[asInt: "millis"] ?? Int(0)
        sequence = 0
        logger = values["logger"] ?? ""
        
        level = Level(values[asString: "level"])
        `class` = values["class"] ?? ""
        method = values["method"] ?? ""
        thread = 1
        message = values["message"] ?? ""
    }
}
