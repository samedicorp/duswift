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
<date>.*?</date>
<millis>.*?</millis>
<sequence>.*?</sequence>
<logger>.*?</logger>
<level>.*?</level>
<class>.*?</class>
<method>.*?</method>
<thread>.*?</thread>
<message>.*?</message>
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

