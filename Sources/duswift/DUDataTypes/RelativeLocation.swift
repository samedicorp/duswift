// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 23/08/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

public struct RelativeLocation: DUDataType, Codable {
    public let constructId: Int
    public let position: Vec3
    public let rotation: Quat
    
    public init?(duData: [String : Any]) {
        guard
            let constructId = duData[asInt: "constructId"],
            let position = duData["position"] as? Vec3,
            let rotation = duData["rotation"] as? Quat
        else {
            return nil
        }
              
        self.constructId = constructId
        self.position = position
        self.rotation = rotation
    }
}
