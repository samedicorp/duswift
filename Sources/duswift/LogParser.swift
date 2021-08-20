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
    
    public func entryStream() -> AsyncStream<LogEntry> {
        return AsyncStream<LogEntry>(LogEntry.self) { continuation in
            Task.detached {
                do {
                    var values: [String: String] = [:]
                    
                    for try await line in url.lines {
                        let range = NSRange(location: 0, length: line.count)
                        if line == "<record>" {
                            values = [:]
                        } else if line == "</record>" {
                            continuation.yield(LogEntry(values))
                            values = [:]
                        } else if let match = re.firstMatch(in: line, options: [], range: range) {
                            let lineString = String(line)
                            let name = String(lineString[match.range(at: 1)])
                            values[name] = String(lineString[match.range(at: 2)])
                        }
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
