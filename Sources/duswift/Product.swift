// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 05/05/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

/// Product definition used in the JSON returned by the in-game schematic API.
public struct JSONProduct: Codable {
    public let name: String
    public let quantity: Double
    public let type: String
    public let id: Int?
}

public struct Product: Codable {
    public let name: String
    public let schematic: Int?
    
    public init(_ productQuantity: JSONProduct) {
        self.name = productQuantity.name
        self.schematic = productQuantity.id
    }
}


public struct FullProduct: Codable {
    public let name: String
    public let schematic: Int?
    public let mass: Double?
    public let volume: Double?
    
    public init(product: Product, recipe: DUMap.Recipe?) {
        self.name = product.name
        self.schematic = product.schematic
        self.mass = recipe?.mass
        self.volume = recipe?.volume
    }
}
