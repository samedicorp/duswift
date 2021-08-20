// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 19/05/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

public struct DUMap {
    public typealias Items = [String:Double]

    public struct Recipe: Codable {
        let tier: Int
        let type: String
        let mass: Double
        let volume: Double
        let outputQuantity: Double
        let time: Double
        let byproducts: Items
        let industries: [String]
        let input: Items
    }


    static let url = URL(string: "https://raw.githubusercontent.com/samedicorp/dumap/dev/data/recipes.json")!

    public static func loadRecipes(normaliseNames: Bool = true) -> [String:Recipe] {
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let decoded = try decoder.decode([String:Recipe].self, from: data)
            if !normaliseNames {
                return decoded
            }
            
            var normalised: [String:Recipe] = [:]
            for recipe in decoded {
                normalised[recipe.key.lowercased()] = recipe.value
            }
            
            return normalised
        } catch {
            print("Failed to decode \(url.lastPathComponent).\n\(error)")
            return [:]
        }
    }
}


