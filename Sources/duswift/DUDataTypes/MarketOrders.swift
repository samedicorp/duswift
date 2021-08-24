// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 24/08/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

struct MarketOrders: DUDataType, Codable {
    let orders: [MarketOrder]
    
    init?(duData: [String : Any]) {
        guard
            let orders = duData["orders"] as? [MarketOrder]
        else {
            return nil
        }
        
        self.orders = orders
    }
}
