// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 24/08/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Files
import Foundation

typealias LogIndex = [String:LogIndexItem]

extension LogIndex {
    static func load(from url: URL) -> LogIndex {
        let decoder = JSONDecoder()
        let logsFolder = ThrowingManager.default.folder(for: url)
        let existingIndex: LogIndex
        if let data = logsFolder.file("status.json").asData, let loaded = try? decoder.decode(LogIndex.self, from: data) {
            existingIndex = loaded
        } else {
            existingIndex = [:]
        }

        var index = LogIndex()
        do {
            try logsFolder.forEach { item in
                if item.name.pathExtension == "xml" {
                    let name = item.name.name
                    let status = existingIndex[name] ?? LogIndexItem(name: name, url: item.url)
                    index[name] = status
                }
            }
        } catch {
            print("Error iterating logs folder: \(error).")
        }
        
        return index
    }
    
    func save(to url: URL) {
        let encoder = JSONEncoder()
        let logsFolder = ThrowingManager.default.folder(for: url)
        let logsFile = logsFolder.file("status.json")
        do {
            let encoded = try encoder.encode(self)
            try encoded.write(to: logsFile.url)
        } catch {
            print("Failed to write log index. \(error)")
        }
    }
}

class LogIndexItem: Codable {
    let name: String
    let url: URL
    var lastLine: Int
    
    init(name: String, url: URL, lastLine: Int = 0) {
        self.name = name
        self.url = url
        self.lastLine = lastLine
    }
    
    func update(_ entry: LogEntry) {
        if entry.line > lastLine {
            lastLine = entry.line
        }
    }
    
}
