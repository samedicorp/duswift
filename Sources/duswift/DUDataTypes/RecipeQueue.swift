// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 24/08/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

struct RecipeQueue: DUDataType, Codable {
    let queue: [RecipeStatus]
    
    init?(duData: [String : Any]) {
        guard
            let queue = duData["queue"] as? [RecipeStatus]
        else {
            return nil
        }
        
        self.queue = queue
    }
}
