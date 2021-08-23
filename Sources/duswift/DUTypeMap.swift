// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 23/08/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

public struct DUTypeMap {
    public let classes: [String:DUDataType.Type]
    
    public static let `default` = DUTypeMap(
        classes: [
            "ConstructGeometry": ConstructGeometry.self,
            "ConstructInfo": ConstructInfo.self,
            "ConstructMutableData": ConstructMutableData.self,
            "ConstructRelativeData": ConstructRelativeData.self,
            "EntityId": EntityId.self,
            "MarketInfo": MarketInfo.self,
            "MarketList": MarketList.self,
            "PlanetDescription": PlanetDescription.self,
            "PlanetProperties": PlanetProperties.self,
            "Quat": Quat.self,
            "RelativeLocation": RelativeLocation.self,
            "Vec3": Vec3.self,
        ]
    )
}