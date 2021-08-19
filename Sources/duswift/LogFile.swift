// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 19/08/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Coercion
import Foundation

struct LogEntry {
    let date: Date
    let millis: Int
    let sequence: Int
    let logger: String
    let level: String
    let klass: String
    let method: String
    let thread: Int
    let message: String
    
    init(_ values: [String:String]) {
        date = Date()
        millis =  values[asInt: "millis"]!
        sequence = 0
        logger = values["logger"] ?? ""
        level = values["level"] ?? ""
        klass = ""
        method = values["method"] ?? ""
        thread = 1
        message = values["message"] ?? ""
    }
}

struct LogFile {
    var entries: [LogEntry]
}

class LogParser: NSObject, XMLParserDelegate {
    var entries: [LogEntry] = []
    var values: [String: String] = [:]
    var value: String = ""
    var valueName: String = ""
    
    func parse(url: URL) -> LogFile {
        entries.removeAll()

        var source = "<xml>"
        if let string = try? String(contentsOf: url) {
            source += string
        }
        source += "</xml>"

        let parser = XMLParser(data: source.data(using: .utf8)!)
        parser.delegate = self
        parser.parse()
        
        return LogFile(entries: entries)
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "record" {
            values = [:]
        } else {
            valueName = elementName
            value = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        value += string
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "record" {
            let entry = LogEntry(values)
            entries.append(entry)
        } else {
            values[valueName] = value
        }
    }
}
