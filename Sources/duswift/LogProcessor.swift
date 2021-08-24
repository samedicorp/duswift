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
    class OrderList {
        var orders: [Int:MarketOrder] = [:]
    }
    
    let dataParser: LogDataParser
    let handlers: [String:LogEntryHandler]
    
    var constructs: [Int:ConstructInfo] = [:]
    var markets: [Int:MarketInfo] = [:]
    var planets: Set<Int> = []
    var recipes: [Int:Recipe] = [:]
    var sellOrders: [Int:OrderList] = [:]
    var buyOrders: [Int:OrderList] = [:]
    var products: [String:Product] = [:]
    var schematics: [Int:CompactSchematic] = [:]
    var classes = LogParser.knownClasses
    var addedClasses = false

    let printConstructKinds = false
    var constructKinds: Set<String> = []
    
    let printObjectTypes = false
    var objectTypes: Set<String> = []
    
    let objectPattern = try! NSRegularExpression(pattern: #"(\w+):\["#, options: [])
    
    let dudeURL: URL
    let privateDataURL: URL
    
    public init() {
        self.dataParser = LogDataParser(map: DUTypeMap.default)
        self.handlers = [
            "game.login": LoginHandler(),
            "network.PIPublication": PublicationHandler(),
            "WC-REL21098-CSTS.game.market": MarketListHandler(),
            "WC-REL21098-CSTS.ui.views.hud.panels": MarketOrdersHandler(),
            "WC-REL21098-CSTS.game.crafting": CraftingHandler()
        ]
        
        self.dudeURL = LogParser.baseURL.appendingPathComponent("../dude/Data/")
        self.privateDataURL = LogParser.baseURL.appendingPathComponent("../dudata/")
    }
    
    func loadProducts() {
        print("Loading product index")
        let decoder = JSONDecoder()
        let url = dudeURL.appendingPathComponent("Products/combined.json")
        let decoded = try! decoder.decode([String:Product].self, from: Data(contentsOf: url))
        products = decoded
    }
    
    func loadSchematics() {
        print("Loading schematic index")
        let decoder = JSONDecoder()
        let url = dudeURL.appendingPathComponent("Schematics/compact.json")
        let decoded = try! decoder.decode([String:CompactSchematic].self, from: Data(contentsOf: url))
        //        schematics = decoded
    }
    
    public func register(market: MarketInfo) {
        markets[market.id] = market
    }
    
    public func register(construct: ConstructInfo) {
        let id = construct.rData.constructId
        constructs[id] = construct
        constructKinds.insert(construct.kind)
        if construct.kind == "PLANET" {
            planets.insert(id)
        }
    }
    
    public func register(recipe: Recipe) {
        recipes[recipe.id] = recipe
    }
    
    public func register(order: MarketOrder) {
        let list: OrderList
        if order.buyQuantity > 0 {
            list = orderList(for: order.itemType, in: &buyOrders)
        } else {
            list = orderList(for: order.itemType, in: &sellOrders)
        }
        
        if let existing = list.orders[order.orderId], existing.updateDate > order.updateDate {
            // skip if existing entry is newer
            return
        }
        
        list.orders[order.orderId] = order
    }
    
    func orderList(for item: Int, in index: inout [Int:OrderList]) -> OrderList {
        if let list = index[item] {
            return list
        }
        
        let list = OrderList()
        index[item] = list
        return list
    }
    
    public func run() {
        print("Parsing file.")
        
        loadProducts()
        loadSchematics()
        loadConstructs()
        loadPlanets()
        loadMarkets()
        loadRecipes()

        let index = loadLogIndex()
        Task {
            for entry in index.values {
                await processLog(entry)
            }
            
            saveLogIndex(index)
            finish()
        }
        
        dispatchMain()
    }

    typealias LogIndex = [String:LogStatus]

    class LogStatus: Codable {
        let name: String
        let url: URL
        var lastLine: Int
        
        init(name: String, url: URL, lastLine: Int = 0) {
            self.name = name
            self.url = url
            self.lastLine = lastLine
        }
    }

    func loadLogIndex() -> LogIndex {
        let decoder = JSONDecoder()
        let base = URL(fileURLWithPath: #file).deletingLastPathComponent().appendingPathComponent("../..")
        let logsFolder = ThrowingManager.default.folder(for: base.appendingPathComponent("/Extras/Logs/"))

        let existingIndex: [String:LogStatus]
        if let data = logsFolder.file("status.json").asData, let loaded = try? decoder.decode([String:LogStatus].self, from: data) {
            existingIndex = loaded
        } else {
            existingIndex = [:]
        }

        var index: [String:LogStatus] = [:]
        do {
            try logsFolder.forEach { item in
                if item.name.pathExtension == "xml" {
                    let name = item.name.name
                    let status = existingIndex[name] ?? LogStatus(name: name, url: item.url)
                    index[name] = status
                }
            }
        } catch {
            print("Error iterating logs folder: \(error).")
        }
        
        return index
    }
    
    func saveLogIndex(_ index: LogIndex) {
        let encoder = JSONEncoder()
        let base = URL(fileURLWithPath: #file).deletingLastPathComponent().appendingPathComponent("../..")
        let logsFolder = ThrowingManager.default.folder(for: base.appendingPathComponent("/Extras/Logs/"))
        let logsFile = logsFolder.file("status.json")
        do {
            let encoded = try encoder.encode(index)
            try encoded.write(to: logsFile.url)
        } catch {
            print("Failed to write log index. \(error)")
        }
    }
    
    func processLog(_ log: LogStatus) async {
        print("Processing log \(log.name)")
        if log.lastLine > 0 {
            print("(skipping \(log.lastLine) lines)")
        }
        
        var count = 0
        let parser = LogParser(url: log.url)
        for await entry in parser.entryStream(startingAtLine: log.lastLine) {
            count += 1
            if !classes.contains(entry.class) {
                print("Found new class \(entry.class)")
                classes.insert(entry.class)
                addedClasses = true
            }
            
            if let handler = handlers[entry.class] {
                handler.handle(entry, processor: self)
            }
            
            //                if entry.message.contains("ElementId"){
            //                    print(entry)
            //                }
            
            if printObjectTypes {
                let message = entry.message
                let matches = objectPattern.matches(in: message, range: NSRange(location: 0, length: message.count))
                for match in matches {
                    objectTypes.insert(String(message[match.range(at: 1)]))
                }
            }
            
            log.lastLine = entry.line
        }
    }
    
    var constructsURL: URL { privateDataURL.appendingPathComponent("Constructs/") }

    func loadConstructs() {
        let decoder = JSONDecoder()
        if let data = try? Data(contentsOf: constructsURL.appendingPathComponent("constructs.json")), let decoded = try? decoder.decode([Int:ConstructInfo].self, from: data) {
            constructs = decoded
        }
    }
    
    func exportConstructs() {
        constructs.save(to: constructsURL, as: "constructs")
    }

    var planetsURL: URL { dudeURL.appendingPathComponent("Planets") }

    func loadPlanets() {
        let decoder = JSONDecoder()
        if let data = try? Data(contentsOf: planetsURL.appendingPathComponent("planets.json")), let decoded = try? decoder.decode([Int:Planet].self, from: data) {
            planets = Set(decoded.keys)
        }
    }
    
    func exportPlanets() {
        let url = planetsURL
        if FileManager.default.fileExists(atURL: url) {
            var planets: [Int:Planet] = [:]
            for id in self.planets {
                let construct = constructs[id]!
                planets[id] = Planet(construct)
            }
            planets.save(to: url, as: "planets")
        }
    }
    
    func loadMarkets() {
        let decoder = JSONDecoder()
        if let data = try? Data(contentsOf: marketsURL.appendingPathComponent("markets.json")), let decoded = try? decoder.decode([Int:MarketInfo].self, from: data) {
            markets = decoded
        }
    }
    
    var marketsURL: URL { dudeURL.appendingPathComponent("Markets") }

    func exportMarkets() {
        markets.save(to: marketsURL, as: "markets")
    }
    
    var recipesURL: URL { dudeURL.appendingPathComponent("Recipes") }

    func loadRecipes() {
        let decoder = JSONDecoder()
        if let data = try? Data(contentsOf: recipesURL.appendingPathComponent("recipes.json")), let decoded = try? decoder.decode([Int:Recipe].self, from: data) {
            recipes = decoded
        }
    }
    
    func exportRecipes() {
        recipes.save(to: recipesURL, as: "recipes")
    }
    
    func exportOrders() {
        print("Sell Orders")
        for order in sellOrders {
            let product = order.key
            print("\nProduct \(product):")
            let listings = order.value.orders.values.sorted(by: { $0.unitPrice.amount < $1.unitPrice.amount })
            for listing in listings {
                if listing.ownerName != "marketbot" {
                    let market = markets[listing.marketId]?.name ?? ""
                    print("- \(listing.ownerName): \(-listing.buyQuantity) @ \(listing.unitPrice.amount), \(market)")
                }
            }
        }
    }
    
    func finish() -> Never {
        if addedClasses {
            save(classes: classes)
        }

        for handler in handlers.values {
            handler.finish(processor: self)
        }
        
        if printConstructKinds {
            print("Found construct kinds")
            for kind in constructKinds {
                print(kind)
            }
        }
        
        if printObjectTypes {
            print("Found object types:")
            for type in objectTypes {
                print(type)
            }
        }
        
        exportConstructs()
        exportPlanets()
        exportMarkets()
        exportRecipes()
        exportOrders()
        
        print("Done.")
        exit(0)
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
