//
//  File.swift
//  File
//
//  Created by Sam Deane on 23/08/2021.
//

import Foundation

struct MarketList: DUDataType, Codable {
    let markets: [MarketInfo]
    
    init?(duData: [String : Any]) {
        guard let markets = duData["markets"] as? [MarketInfo] else { return nil }
        self.markets = markets
    }
}
