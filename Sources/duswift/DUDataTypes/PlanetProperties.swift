// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 23/08/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

public struct PlanetProperties: DUDataType, Codable {
    let description: PlanetDescription
    let ores: [String]
    let isTutorial: Bool
    let isSanctuary: Bool
    let territoryTileSize: Int
    let altitudeReferenceRadius: Double
    let minGenerationRadiusHint: Int
    let maxGenerationRadiusHint: Int
    let seaLevelGravity: Double
    let seaLevelRadius: Double?
    let atmosphere: Double?
    let clouds: Double?

    public init?(duData: [String : Any]) {
        guard
            let description = duData["description"] as? PlanetDescription,
            let ores = duData["ores"] as? [String],
            let isTutorial = duData[asBool: "isTutorial"],
            let isSanctuary = duData[asBool: "isSanctuary"],
            let territoryTileSize = duData[asInt: "territoryTileSize"],
            let altitudeReferenceRadius = duData[asDouble: "altitudeReferenceRadius"],
            let minGenerationRadiusHint = duData[asInt: "minGenerationRadiusHint"],
            let maxGenerationRadiusHint = duData[asInt: "maxGenerationRadiusHint"],
            let seaLevelGravity = duData[asDouble: "seaLevelGravity"]
        else {
            return nil
        }
        
        self.description = description
        self.ores = ores
        self.isTutorial = isTutorial
        self.isSanctuary = isSanctuary
        self.territoryTileSize = territoryTileSize
        self.altitudeReferenceRadius = altitudeReferenceRadius
        self.minGenerationRadiusHint = minGenerationRadiusHint
        self.maxGenerationRadiusHint = maxGenerationRadiusHint
        self.seaLevelGravity = seaLevelGravity
        self.seaLevelRadius = duData[asDouble: "seaLevelRadius"]
        self.atmosphere = duData[asDouble: "atmosphere"]
        self.clouds = duData[asDouble: "clouds"]
    }
}
