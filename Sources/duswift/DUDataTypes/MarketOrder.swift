// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 24/08/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

public struct MarketOrder: DUDataType, Codable {
    let marketId: Int
    let orderId: Int
    let itemType: Int
    let buyQuantity: Int
    let expirationDate: Date
    let updateDate: Date
    let ownerId: EntityId
    let ownerName: String
    let unitPrice: Currency
    
    public init?(duData: [String : Any]) {
        guard
            let marketId = duData[asInt: "marketId"],
            let orderId = duData[asInt: "orderId"],
            let itemType = duData[asInt: "itemType"],
            let buyQuantity = duData[asInt: "buyQuantity"],
            let expirationDate = duData["expirationDate"] as? Date,
            let updateDate = duData["updateDate"] as? Date,
            let ownerId = duData["ownerId"] as? EntityId,
            let ownerName = duData[asString: "ownerName"],
            let unitPrice = duData["unitPrice"] as? Currency
        else {
            return nil
        }
        
        self.marketId = marketId
        self.orderId = orderId
        self.itemType = itemType
        self.buyQuantity = buyQuantity
        self.expirationDate = expirationDate
        self.updateDate = updateDate
        self.ownerId = ownerId
        self.ownerName = ownerName
        self.unitPrice = unitPrice
    }
}
