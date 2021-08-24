// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 24/08/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

struct Planet: Codable {
    let id: Int
    let name: String
    let discoveredBy: String?
    let type: String?
    let biosphere: String?
    let classification: String?
    let habitabilityClass: String?
    let information: String?
    let index: Int
    let satellites: Int
    let ores: [String]
    let seaLevelGravity: Double
    let seaLevelRadius: Double?
    let tileSize: Int
    let radius: Double
    let position: Vec3
    
    init?(_ construct: ConstructInfo) {
        guard let properties = construct.planetProperties else { return nil }
        
        id = construct.rData.constructId
        name = properties.description.displayName
        discoveredBy = properties.description.discoveredBy
        type = properties.description.type
        biosphere = properties.description.biosphere
        classification = properties.description.classification
        habitabilityClass = properties.description.habitabilityClass
        information = properties.description.information
        index = properties.description.positionFromSun
        satellites = properties.description.numSatellites
        ores = properties.ores
        seaLevelGravity = properties.seaLevelGravity
        seaLevelRadius = properties.seaLevelRadius
        tileSize = properties.territoryTileSize
        radius = properties.altitudeReferenceRadius
        position = construct.rData.position
    }
}

extension Planet: JSONIndexable {
    var jsonID: Int { return id }
    var jsonName: String { return name }
}
