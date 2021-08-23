// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 23/08/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

public struct ConstructMutableData: DUDataType, Codable {
    public let ownerId: EntityId
    
    public init?(duData: [String : Any]) {
        guard
            let ownerId = duData["ownerId"] as? EntityId
        else {
            return nil
        }
        
        self.ownerId = ownerId
    }
}
