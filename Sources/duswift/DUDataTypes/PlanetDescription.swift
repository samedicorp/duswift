// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 23/08/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

public struct PlanetDescription: DUDataType, Codable {
    let displayName: String
    let discoveredBy: String?
    let type: String?
    let biosphere: String?
    let classification: String?
    let habitabilityClass: String?
    let information: String?
    let positionFromSun: Int
    let numSatellites: Int
    
    public init?(duData: [String : Any]) {
        guard
            let displayName = duData[asString: "displayName"]
        else {
            return nil
        }
        
        self.displayName = displayName
    }
}
