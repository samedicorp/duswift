// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 20/08/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import duswift
import Foundation

struct DULog {
    func run() {
        print("Parsing file.")
        let base = URL(fileURLWithPath: #file).deletingLastPathComponent().appendingPathComponent("../..")
        let url = base.appendingPathComponent("/Extras/Logs/large.xml")
        let parser = LogParser(url: url)

        
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
                if count % 10000 == 0 {
                    print("\(count)...")
                }
            }
            
            if addedClasses {
                save(classes: classes)
            }
            
            print("Done.")
        }
        
        dispatchMain()
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
