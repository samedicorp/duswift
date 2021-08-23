// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 23/08/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

public struct PlanetProperties: DUDataType, Codable {
    let description: PlanetDescription
    
    public init?(duData: [String : Any]) {
        guard
            let description = duData["description"] as? PlanetDescription
        else {
            return nil
        }
        
        self.description = description
    }
}
