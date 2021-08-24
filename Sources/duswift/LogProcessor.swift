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
        let decoder = JSONDecoder()
        let url = dudeURL.appendingPathComponent("Products/combined.json")
        let decoded = try! decoder.decode([String:Product].self, from: Data(contentsOf: url))
        products = decoded
    }

    func loadSchematics() {
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
        let base = URL(fileURLWithPath: #file).deletingLastPathComponent().appendingPathComponent("../..")
        let url = base.appendingPathComponent("/Extras/Logs/large.xml")
        let parser = LogParser(url: url)
        loadProducts()
        loadSchematics()
        
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
        let url = LogParser.baseURL.appendingPathComponent("../dudata/Constructs/")
        let encoder = JSONEncoder()
        for construct in constructs.values {
            do {
                let encoded = try encoder.encode(construct)
                try encoded.write(to: url.appendingPathComponent("\(construct.rData.constructId).json"))
            } catch {
                print("Couldn't save construct \(construct.rData.name)")
            }
        }
    }
    
    
    func exportPlanets() {
        let url = dudeURL.appendingPathComponent("Planets")
        if FileManager.default.fileExists(atURL: url) {
            var planets: [Int:Planet] = [:]
            for id in self.planets {
                let construct = constructs[id]!
                planets[id] = Planet(construct)
            }
            planets.save(to: url, as: "planets")
        }
    }
    
    func exportMarkets() {
        let url = dudeURL.appendingPathComponent("Markets")
        if FileManager.default.fileExists(atURL: url) {
            markets.save(to: url, as: "markets")
        }
    }
    
    func exportRecipes() {
        let url = dudeURL.appendingPathComponent("Recipes")
        if FileManager.default.fileExists(atURL: url) {
            recipes.save(to: url, as: "recipes")
        }
    }
    
    func exportOrders() {
        print("Sell Orders")
        for order in sellOrders {
            let product = order.key
            print("Product \(product) \(String(format: "%x", product)):")
//            print(product & 0x7FFFFFF)
//            print(product & 0x3FFFFFF)
//            print(product & 0x1FFFFFF)
//            print(product & 0x0FFFFFF)
//            let listings = order.value.orders.values.sorted(by: { $0.unitPrice.amount < $1.unitPrice.amount })
//            for listing in listings {
//                let market = markets[listing.marketId]?.name ?? ""
//                print("\(listing.ownerName): \(-listing.buyQuantity) @ \(listing.unitPrice.amount), \(market)")
//            }
        }
    }
    
    func finish() -> Never {
    
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
