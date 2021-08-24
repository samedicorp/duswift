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
    let positionFromSun: Double
    let numSatellites: Int
    
    public init?(duData: [String : Any]) {
        guard
            let displayName = duData[asString: "displayName"],
            let discoveredBy = duData[asString: "discoveredBy"],
            let type = duData[asString: "type"],
            let biosphere = duData[asString: "biosphere"],
            let classification = duData[asString: "classification"],
            let habitabilityClass = duData[asString: "habitabilityClass"],
            let information = duData[asString: "information"],
            let positionFromSun = duData[asDouble: "positionFromSun"],
            let numSatellites = duData[asInt: "numSatellites"]
        else {
            return nil
        }
        
        self.displayName = displayName
        self.discoveredBy = discoveredBy
        self.type = type
        self.biosphere = biosphere
        self.classification = classification
        self.habitabilityClass = habitabilityClass
        self.information = information
        self.positionFromSun = positionFromSun
        self.numSatellites = numSatellites
    }
}
