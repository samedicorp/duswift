// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 23/08/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

public struct ConstructGeometry: DUDataType, Codable {
    let size: Int
    let kind: String
    let voxelLod0: Int
    let radius: Int?
    let minRadius: Int?
    let maxRadius: Int?
    
    public init?(duData: [String : Any]) {
        guard
            let size = duData[asInt: "size"],
            let kind = duData[asString: "kind"],
            let voxelLod0 = duData[asInt: "voxelLod0"]
        else {
            return nil
        }
        
        self.size = size
        self.kind = kind
        self.voxelLod0 = voxelLod0
        self.radius = duData[asInt: "radius"]
        self.minRadius = duData[asInt: "minRadius"]
        self.maxRadius = duData[asInt: "maxRadius"]
    }
}
