// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 24/08/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

struct Currency: DUDataType, Codable {
    let amount: Double
    
    init?(duData: [String : Any]) {
        guard
            let amount = duData[asDouble: "amount"]
        else {
            return nil
        }
        
        self.amount = amount
    }
}

