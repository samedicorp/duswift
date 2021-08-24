// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 23/08/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

public struct MarketInfo: DUDataType, Codable {
    public let id: Int
    public let name: String
    public let creatorName: String
    public let valueTax: Double
    public let dailyStorageFee: Double
    public let orderFee: Double
    public let capacity: Double
    public let position: Vec3
    public let relativeLocation: RelativeLocation
    public let parentConstruct: Int
    public let creatorId: EntityId
    
    public init?(duData: [String : Any]) {
        guard
            let name = duData[asString: "name"],
            let id = duData[asInt: "marketId"],
            let creatorName = duData[asString: "creatorName"],
            let valueTax = duData[asDouble: "valueTax"],
            let storageFee = duData[asDouble: "dailyStorageFee"],
            let orderFee = duData[asDouble: "orderFee"],
            let capacity = duData[asDouble: "capacity"],
            let position = duData["position"] as? Vec3,
            let relativeLocation = duData["relativeLocation"] as? RelativeLocation,
            let parentConstruct = duData[asInt: "parentConstruct"],
            let creatorId = duData["creatorId"] as? EntityId
        else {
            return nil
        }
        
        self.name = name
        self.id = id
        self.creatorName = creatorName
        self.valueTax = valueTax
        self.dailyStorageFee = storageFee
        self.orderFee = orderFee
        self.capacity = capacity
        self.position = position
        self.parentConstruct = parentConstruct
        self.relativeLocation = relativeLocation
        self.creatorId = creatorId
    }
}

extension MarketInfo: JSONIndexable {
    var jsonID: Int { return id }
    var jsonName: String { return name }
}
