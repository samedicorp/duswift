// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 05/05/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

/// Schematic definition used in the JSON returned by the in-game schematic API.
public struct JSONSchematic: Codable {
    public let id: Int
    public let name: String
    public let ingredients: [JSONProduct]
    public let level: Int
    public let products: [JSONProduct]
    public let time: Double

    public var summary: String {
        let ingredientText: String
        if ingredients.count == 0 {
            ingredientText = ""
        } else {
            let formatted = ingredients.map({ "- \($0.name) x \($0.quantity)"}).joined(separator: "\n")
            ingredientText = "\nIngredients:\n\(formatted)"
        }
        
        let outputText: String
        if products.count == 0 {
            outputText = ""
        } else {
            let formatted = products.map({ "- \($0.name) x \($0.quantity)"}).joined(separator: "\n")
            outputText = "\nOutput:\n\(formatted)\n"
        }

        return "Name: \(name)\nLevel: \(level)\nTime: \(time)\(ingredientText)\(outputText)\n"
    }

    public var asLUA: String {
        var items: [String] = []
        items.append("name = \"\(name)\"")
        items.append("level = \(level)")
        items.append("time = \(time)")

        if ingredients.count > 0 {
            let sortedIngredients = ingredients.sorted(by: {$0.name < $1.name })
            let formatted = sortedIngredients.map({ "[\"\($0.type)\"] = \($0.quantity)"}).joined(separator: ", ")
            items.append("input = {\(formatted)}")
        }
        
        if products.count > 0 {
            let sortedProducts = products.sorted(by: { $0.name < $1.name })
            let formatted = sortedProducts.map({ "[\"\($0.type)\"] = \($0.quantity)"}).joined(separator: ", ")
            if products.count > 1, let main = products.first?.type {
                items.append("makes = \"\(main)\"")
            }
            items.append("output = {\(formatted)}")
        }

        return "{ \(items.joined(separator: ", ")) }"
    }

}

/// Array of JSONSchematic records, e.g. as loaded from `dude/Data/Schematics/raw.json`
/// (derived from the in-game schematic API)
public typealias JSONSchematics = [String:JSONSchematic]

public extension JSONSchematics {
    static func load(from url: URL) throws -> Self {
        let decoder = JSONDecoder()
        let data = try Data(contentsOf: url)
        return try decoder.decode(Self.self, from: data)
    }
    
    var sortedByLevel: [JSONSchematic] {
        return values
            .sorted(by: { r1, r2 in
                if r1.level == r2.level {
                    return r1.name < r2.name
                } else {
                    return r1.level < r2.level
                }
            })

    }
}

extension JSONSchematic: CustomStringConvertible {
    public var description: String {
        return summary
    }
}

public struct CompactSchematic: Codable {
    let time: Int
    let level: Int
    let ingredients: [String:Double]
    let products: [String:Double]
}
