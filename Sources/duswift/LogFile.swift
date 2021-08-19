// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 19/08/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Coercion
import Foundation

public let knownClasses: Set<String> = [
    "Shared.ASyncCurl",
    "Shared.ItemTree",
    "WC-REL21098-CSTS.engine.app",
    "WC-REL21098-CSTS.engine.gui",
    "WC-REL21098-CSTS.engine.gui.integration",
    "WC-REL21098-CSTS.engine.util",
    "WC-REL21098-CSTS.engine.util.filesystem",
    "WC-REL21098-CSTS.engine.util.locale",
    "WC-REL21098-CSTS.game",
    "WC-REL21098-CSTS.game.world",
    "WC-REL21098-CSTS.ui.views",
    "anticheat.thread",
    "engine.sparseTexture",
    "gui",
    "network.PIAnalytics",
    "nqsettings",
    "pkfx.BOOT",
    "pkfx.Geometrics|Mesh",
    "pkfx.Geometrics|MeshDeformers",
    "pkfx.Kernel|CapsCpu",
    "pkfx.Kernel|CapsMem",
    "pkfx.Kernel|Plugins",
    "pkfx.Kernel|Scheduler",
    "pkfx.Particles",
    "squarion.Context",
    "squarion.sys.threading",
    "unigine",
    "voxel.textures"
]

let pattern = """
<record>
<date>.*</date>
<millis>.*</millis>
<sequence>.*</sequence>
<logger>.*</logger>
<level>.*</level>
<class>.*</class>
<method>.*</method>
<thread>.*</thread>
<message>.*</message>
</record>
"""

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

public struct LogFile: Codable {
    public var entries: [LogEntry]
}

public class LogParser: NSObject {
    var entries: [LogEntry] = []
    var values: [String: String] = [:]
    var value: String = ""
    var valueName: String = ""
    
    public func parse(url: URL) -> LogFile {
        entries.removeAll()

        print("Loading")
        var source = "<xml>"
        if let string = try? String(contentsOf: url) {
            source += string
        }
        source += "</xml>"

        print("Parsing")
        let parser = XMLParser(data: source.data(using: .utf8)!)
        parser.delegate = self
        parser.parse()

        print("Done")
        return LogFile(entries: entries)
    }
}

extension LogParser: XMLParserDelegate {
    public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "record" {
            values = [:]
        } else {
            valueName = elementName
            value = ""
        }
    }
    
    public func parser(_ parser: XMLParser, foundCharacters string: String) {
        value += string
    }
    
    public func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "record" {
            let entry = LogEntry(values)
            entries.append(entry)
        } else {
            values[valueName] = value
        }
    }
}
