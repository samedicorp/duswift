// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 20/08/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import duswift
import Foundation

struct DULog {
    static func main() {
        print("Parsing file.")
        let url = URL(fileURLWithPath: #file).deletingLastPathComponent().appendingPathComponent("../../Extras/Logs/large.xml")
        let parser = LogParser(url: url)

        Task {
            for await entry in parser.entryStream() {
                print(entry.level)
                print(entry.message)
            }
        }
        
        dispatchMain()
    }
}

DULog.main()
