// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 23/08/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

public struct EntityId: DUDataType, Codable {
    public let playerId: Int
    public let organizationId: Int
    
    public init?(duData: [String : Any]) {
        guard
            let playerId = duData[asInt: "playerId"],
            let organizationId = duData[asInt: "organizationId"]
        else {
            return nil
        }
        
        self.playerId = playerId
        self.organizationId = organizationId
    }
}
