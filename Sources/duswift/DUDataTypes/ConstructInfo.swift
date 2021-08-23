// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 23/08/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

public struct ConstructInfo: DUDataType, Codable {
    public let rData: ConstructRelativeData
    public let creatorId: EntityId
    public let kind: String

    public init?(duData: [String : Any]) {
        guard
            let rData = duData["rData"] as? ConstructRelativeData,
            let creatorId = duData["creatorId"] as? EntityId,
            let kind = duData[asString: "kind"]
        else {
            return nil
        }
        
        self.rData = rData
        self.creatorId = creatorId
        self.kind = kind
    }
}
