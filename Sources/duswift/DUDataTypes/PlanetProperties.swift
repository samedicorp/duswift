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
    let altitudeReferenceRadius: 10000
    let minGenerationRadiusHint: Int
    let maxGenerationRadiusHint: Int
    let seaLevelGravity: Double
    let seaLevelRadius: Double?
    let atmosphere: Double?
    let clouds: Double?

    public init?(duData: [String : Any]) {
        guard
            let description = duData["description"] as? PlanetDescription
        else {
            return nil
        }
        
        self.description = description
    }
}
