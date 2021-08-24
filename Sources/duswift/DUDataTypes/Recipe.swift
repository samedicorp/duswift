//
//  File.swift
//  File
//
//  Created by Sam Deane on 24/08/2021.
//

import Foundation

public struct Recipe: DUDataType, Codable {
    let id: Int
    let time: Double
    let nanocraftable: Bool
    let ingredients: [Ingredient]
    let products: [Ingredient]
    let producers: [Int]
    
    public init?(duData: [String : Any]) {
        guard
            let id = duData[asInt: "id"],
            let time = duData[asDouble: "time"],
            let nanocraftable = duData[asBool: "nanocraftable"],
            let ingredients = duData["ingredients"] as? [Ingredient],
            let products = duData["products"] as? [Ingredient],
            let producers = duData["producers"] as? [Int]
        else {
            return nil
        }
        
        self.id = id
        self.time = time
        self.nanocraftable = nanocraftable
        self.ingredients = ingredients
        self.products = products
        self.producers = producers
    }
}

extension Recipe: JSONIndexable {
    var jsonID: Int { return id }
    var jsonName: String { return "\(id)" }
}
