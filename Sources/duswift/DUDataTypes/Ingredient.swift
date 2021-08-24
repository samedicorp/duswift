// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 24/08/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

struct Ingredient: DUDataType, Codable {
    let itemId: Int
    let quantity: Double
    
    init?(duData: [String : Any]) {
        guard
            let itemId = duData[asInt: "itemId"],
            let quantity = duData[asDouble: "quantity"]
        else {
            return nil
        }
        
        self.itemId = itemId
        self.quantity = quantity
    }
}
