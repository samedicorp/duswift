// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 23/08/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

public struct ConstructRelativeData: DUDataType, Codable {
    let constructId: Int
    let name: String
    let parentId: Int
    let position: Vec3
    let rotation: Quat
    let geometry: ConstructGeometry
    let isStatic: Bool
    let blueprintId: Int?
    
    public init?(duData: [String : Any]) {
        guard
            let constructId = duData[asInt: "constructId"],
            let name = duData[asString: "name"],
            let parentId = duData[asInt: "parentId"],
            let position = duData["position"] as? Vec3,
            let rotation = duData["rotation"] as? Quat,
            let geometry = duData["geometry"] as? ConstructGeometry,
            let isStatic = duData[asBool: "isStatic"]                
        else {
            return nil
        }
        
        self.constructId = constructId
        self.name = name
        self.parentId = parentId
        self.position = position
        self.rotation = rotation
        self.geometry = geometry
        self.isStatic = isStatic
        self.blueprintId = duData[asInt: "blueprintId"]
    }
}
