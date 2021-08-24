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


class OrderList: Codable {
    let id: Int
    var orders: [Int:MarketOrder]
    
    init(id: Int) {
        self.id = id
        self.orders = [:]
    }
}

extension OrderList: JSONIndexable {
    var jsonID: Int { return id }
    var jsonName: String { return "\(id)" }
}

public class LogProcessor {
    let dataParser: LogDataParser
    let handlers: [String:LogEntryHandler]
    
    var constructs: [Int:ConstructInfo] = [:]
    var constructsUpdated = false
    
    var markets: [Int:MarketInfo] = [:]
    var marketsUpdated = false
    
    var planets: Set<Int> = []
    var planetsUpdated = false
    
    var recipes: [Int:Recipe] = [:]
    var recipesUpdated = false
    
    var ordersUpdated = false
    var sellOrders: [Int:OrderList] = [:]
    var buyOrders: [Int:OrderList] = [:]
    
    var products: [String:Product] = [:]
    var productsUpdated = false

    var schematics: [Int:CompactSchematic] = [:]
    var schematicsUpdated = false
    
    var classes = LogParser.knownClasses
    var classesUpdated = false

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
        constructsUpdated = true
        if construct.kind == "PLANET" && !planets.contains(id) {
            planets.insert(id)
            planetsUpdated = true
        }
    }
    
    public func register(recipe: Recipe) {
        recipes[recipe.id] = recipe
        recipesUpdated = true
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
        
        ordersUpdated = true
        list.orders[order.orderId] = order
    }
    
    func orderList(for item: Int, in index: inout [Int:OrderList]) -> OrderList {
        if let list = index[item] {
            return list
        }
        
        let list = OrderList(id: item)
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

        let index = LogIndex.load(from: logFolderURL)
        Task {
            for entry in index.values {
                await processLog(entry)
            }
            
            index.save(to: logFolderURL)
            finish()
        }
        
        dispatchMain()
    }


    var logFolderURL: URL {
        let base = URL(fileURLWithPath: #file).deletingLastPathComponent().appendingPathComponent("../..")
        return base.appendingPathComponent("/Extras/Logs/")
    }

    func loadLogIndex() -> LogIndex {
        return LogIndex.load(from: logFolderURL)
    }
    
    func saveLogIndex(_ index: LogIndex) {
        index.save(to: logFolderURL)
    }
    
    func processLog(_ log: LogIndexItem) async {
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
                classesUpdated = true
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
        if constructsUpdated {
            constructs.save(to: constructsURL, as: "constructs")
        }
    }

    var planetsURL: URL { dudeURL.appendingPathComponent("Planets") }

    func loadPlanets() {
        let decoder = JSONDecoder()
        if let data = try? Data(contentsOf: planetsURL.appendingPathComponent("planets.json")), let decoded = try? decoder.decode([Int:Planet].self, from: data) {
            planets = Set(decoded.keys)
        }
    }
    
    func exportPlanets() {
        if planetsUpdated {
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
    }
    
    var marketsURL: URL { dudeURL.appendingPathComponent("Markets") }

    func loadMarkets() {
        let decoder = JSONDecoder()
        if let data = try? Data(contentsOf: marketsURL.appendingPathComponent("markets.json")), let decoded = try? decoder.decode([Int:MarketInfo].self, from: data) {
            markets = decoded
        }
    }
    
    func exportMarkets() {
        if marketsUpdated {
            markets.save(to: marketsURL, as: "markets")
        }
    }
    
    var recipesURL: URL { dudeURL.appendingPathComponent("Recipes") }

    func loadRecipes() {
        let decoder = JSONDecoder()
        if let data = try? Data(contentsOf: recipesURL.appendingPathComponent("recipes.json")), let decoded = try? decoder.decode([Int:Recipe].self, from: data) {
            recipes = decoded
        }
    }
    
    func exportRecipes() {
        if recipesUpdated {
            recipes.save(to: recipesURL, as: "recipes")
        }
    }
    
    var ordersURL: URL { privateDataURL.appendingPathComponent("Orders/") }
    
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
        
        sellOrders.save(to: ordersURL, as: "sell")
        buyOrders.save(to: ordersURL, as: "buy")
    }
    
    func finish() -> Never {
        if classesUpdated {
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
