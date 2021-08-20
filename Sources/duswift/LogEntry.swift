// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 20/08/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

public struct LogEntry: Codable {
    public enum Level: Codable {
        case unknown
        case debug
        case info
        case warning
        case error

        init(_ string: String?) {
            switch string?.lowercased() {
                case "debug": self = .debug
                case "info": self = .info
                case "warning": self = .warning
                case "error": self = .error
                default:
                    print(string == nil ? "Missing level" : "Unknown level \(string!)")
                    self = .unknown
            }
        }
    }
    
    static let formatter = ISO8601DateFormatter()
    public let line: Int
    public let dateString: String
    public let millis: Int
    public let sequence: Int
    public let logger: String
    public let level: Level
    public let `class`: String
    public let method: String
    public let thread: Int
    public let message: String
    
    public var date: Date {
        Self.formatter.date(from: dateString)!
    }
}

extension LogEntry: CustomStringConvertible {
    public var description: String {
        "#\(sequence) \(date), \(level), \(`class`)\n\(message)"
    }
}
