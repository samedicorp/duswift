// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 20/08/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import ElegantStrings
import Foundation

public struct LogParser {
    public static let knownClasses = Self.loadClasses()

    public static let baseURL = URL(fileURLWithPath: #file).deletingLastPathComponent().appendingPathComponent("../..")

    fileprivate let url: URL
    fileprivate let re = try! NSRegularExpression(pattern: "<(.*?)>(.*)</\\1>", options: .allowCommentsAndWhitespace)
    
    public init(url: URL) {
        self.url = url
    }
    
    public func entryStream(startingAtLine startLine: Int = 0) -> AsyncStream<LogEntry> {
        return AsyncStream<LogEntry>(LogEntry.self) { continuation in
            Task.detached {
                do {
                    var date = ""
                    var millis = 0
                    var sequence = 0
                    var logger = ""
                    var level = LogEntry.Level.unknown
                    var `class` = ""
                    var method = ""
                    var thread = 0
                    var message = ""
                    var buffer = ""
                    var count = 0
                    for try await line in url.lines.dropFirst(startLine) {
                        if line == "<record>" {
                            date = ""
                            millis = 0
                            sequence = 0
                            logger = ""
                            level = .unknown
                            `class` = ""
                            method = ""
                            thread = 0
                            message = ""
                            
                        } else if line == "</record>" {
                            continuation.yield(
                                LogEntry(
                                    line: count,
                                    dateString: date,
                                    millis: millis,
                                    sequence: sequence,
                                    logger: logger,
                                    level: level,
                                    class: `class`,
                                    method: method,
                                    thread: thread,
                                    message: message
                                )
                            )
                        } else {
                            buffer += line
                            if buffer.last == ">" {
                                let range = NSRange(location: 0, length: buffer.count)
                                if let match = re.firstMatch(in: buffer, options: [], range: range) {
                                    let key = String(buffer[match.range(at: 1)])
                                    let value = String(buffer[match.range(at: 2)])
                                    buffer = ""
                                    switch key {
                                        case "date": date = value
                                        case "millis": millis = Int(value) ?? 0
                                        case "sequence": sequence = Int(value) ?? 0
                                        case "logger": logger = value
                                        case "level": level = LogEntry.Level(value)
                                        case "class": `class` = value
                                        case "method": method = value
                                        case "thread": thread = Int(value) ?? 0
                                        case "message": message += value
                                        default:
                                            print("Unexpected value: \(key) = \(value)")
                                    }
                                }
                            }
                        }
                        
                        count += 1
                    }
                } catch {
                    print("error \(error)")
                }
                
                continuation.finish()
            }
        }
    }
    
    fileprivate static func loadClasses() -> Set<String> {
        let decoder = JSONDecoder()
        let url = Bundle.module.url(forResource: "classes", withExtension: "json")!
        let list = try? decoder.decode([String].self, from: Data(contentsOf: url))
        return Set(list ?? [])
    }
}
