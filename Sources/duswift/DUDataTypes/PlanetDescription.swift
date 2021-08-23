// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 23/08/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

public struct PlanetDescription: DUDataType, Codable {
    let displayName: String
    
    public init?(duData: [String : Any]) {
        guard
            let displayName = duData[asString: "displayName"]
        else {
            return nil
        }
        
        self.displayName = displayName
    }
}
