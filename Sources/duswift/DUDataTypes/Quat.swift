// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 23/08/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Coercion
import Foundation

public struct Quat: DUDataType, Codable {
    public let x: Double
    public let y: Double
    public let z: Double
    public let w: Double

    public init?(duData: [String : Any]) {
        guard let values = duData["values"] as? [Double], values.count == 4 else { return nil }
        x = values[0]
        y = values[1]
        z = values[2]
        w = values[3]
    }
}
