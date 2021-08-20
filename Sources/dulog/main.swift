// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 20/08/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import duswift
import Foundation

extension NSRegularExpression {
    func captures(in string: String) -> [String]? {
        guard let match = firstMatch(in: string, options: [], range: NSRange(location: 0, length: string.count)) else { return nil }
        
        var captures: [String] = []
        for n in 1 ..< match.numberOfRanges {
            let capture = string[match.range(at: n)]
            captures.append(String(capture))
        }
        return captures
    }
}


struct DULog {
    let loginPattern = try! NSRegularExpression(pattern: "playerId = (\\d+), username = (\\w+)")
    
    func run() {
        print("Parsing file.")
        let base = URL(fileURLWithPath: #file).deletingLastPathComponent().appendingPathComponent("../..")
        let url = base.appendingPathComponent("/Extras/Logs/large.xml")
        let parser = LogParser(url: url)

        let handlers: [String:(LogEntry) -> Void] = [
            "game.login": handleLogin,
            "network.PIPublication": handlePublication
        ]
        
        Task {
            var classes = LogParser.knownClasses
            var addedClasses = false
            var count = 0

            for await entry in parser.entryStream() {
                count += 1
                if !classes.contains(entry.class) {
                    print("Found new class \(entry.class)")
                    classes.insert(entry.class)
                    addedClasses = true
                }
                
//                if count % 10000 == 0 {
//                    print("\(entry.sequence)...")
//                }
                
                if let handler = handlers[entry.class] {
                    handler(entry)
                } else if entry.message.localizedCaseInsensitiveContains("Samedi") {
                    print("\(entry)\n\n")
                }

            }
            
            if addedClasses {
                save(classes: classes)
            }
            
            print("Done.")
        }
        
        dispatchMain()
    }
    
    func handleLogin(_ entry: LogEntry) {
        if let match = loginPattern.captures(in: entry.message) {
            print("Login \(match[1]) (\(match[0])).")
        }
    }
    
    func handlePublication(_ entry: LogEntry) {
        if entry.message.starts(with: "did receive ConstructInfo") {
            handleConstructInfo(entry)
        }
    }
    
    func handleConstructInfo(_ entry: LogEntry) {
        print(entry)
    }
    func save(classes: Set<String>) {
        do {
            print("Saving classes index.")
            let url = LogParser.baseURL.appendingPathComponent("Sources/duswift/Resources/classes.json")
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            let encoded = try encoder.encode(classes)
            try encoded.write(to: url)
        } catch {
            print("Error writing classes: \(error)")
        }
    }
}

DULog().run()
