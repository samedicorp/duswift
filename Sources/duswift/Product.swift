// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 05/05/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

public struct ProductQuantity: Codable {
    public let name: String
    public let quantity: Double
    public let type: String
    public let id: Int?
}

public struct Product: Codable {
    public let name: String
    public let schematic: Int?
    
    public init(_ productQuantity: ProductQuantity) {
        self.name = productQuantity.name
        self.schematic = productQuantity.id
    }
}
