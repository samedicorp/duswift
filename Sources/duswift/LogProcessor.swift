// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 20/08/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Expressions
import Files
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


public class LogProcessor {
    let dataParser: LogDataParser
    let handlers: [String:LogEntryHandler]
    
    var constructs: [Int:ConstructInfo] = [:]
    var constructKinds: Set<String> = []
    var markets: [Int:MarketInfo] = [:]
    var planets: Set<Int> = []

    public init() {
        self.dataParser = LogDataParser(map: DUTypeMap.default)
        self.handlers = [
            "game.login": LoginHandler(),
            "network.PIPublication": PublicationHandler(),
            "WC-REL21098-CSTS.game.market": MarketListHandler(),
            "WC-REL21098-CSTS.ui.views.hud.panels": MarketOrdersHandler()
        ]
    }
    
    public func append(market: MarketInfo) {
        markets[market.id] = market
    }
    
    public func append(construct: ConstructInfo) {
        let id = construct.rData.constructId
        constructs[id] = construct
        constructKinds.insert(construct.kind)
        if construct.kind == "PLANET" {
            planets.insert(id)
        }
    }
    
    public func run() {
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
                
//                if count % 10000 == 0 {
//                    print("\(entry.sequence)...")
//                }
                
                if let handler = handlers[entry.class] {
                    handler.handle(entry, processor: self)
                }

            }
            
            if addedClasses {
                save(classes: classes)
            }

            finish()
        }
        
        dispatchMain()
    }

    func exportConstructs() {
        print("Exporting constructs")
        for kind in constructKinds {
            print(kind)
        }
        let url = LogParser.baseURL.appendingPathComponent("Extras/Exported/Constructs/")
        let encoder = JSONEncoder()
        for construct in constructs.values {
            do {
                let encoded = try encoder.encode(construct)
                try encoded.write(to: url.appendingPathComponent("\(construct.rData.constructId).json"))
                print(construct.rData.name)
            } catch {
                print("Couldn't save construct \(construct.rData.name)")
            }
        }
    }
    
    
    func exportPlanets() {
        print("Exporting planets")
        let url = LogParser.baseURL.appendingPathComponent("../dude/Data/Planets")
        if FileManager.default.fileExists(atURL: url) {
            var planets: [Int:ConstructInfo] = [:]
            for id in self.planets {
                planets[id] = constructs[id]!
            }
            planets.save(to: url, as: "planets")
        }
    }
    
    func exportMarkets() {
        let url = LogParser.baseURL.appendingPathComponent("../dude/Data/Markets")
        if FileManager.default.fileExists(atURL: url) {
            markets.save(to: url, as: "markets")
        }
    }
    
    func finish() {
    
        for handler in handlers.values {
            handler.finish(processor: self)
        }

        exportConstructs()
        exportPlanets()
        exportMarkets()
        print("Done.")
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
