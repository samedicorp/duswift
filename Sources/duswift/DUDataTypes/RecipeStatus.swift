// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 24/08/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

struct RecipeStatus: DUDataType, Codable {
    let id: Int
    let status: String
    let recipe: Recipe
    let start: Int
    let end: Int
    let remainingTime: Int
    let bulk: Int

    init?(duData: [String : Any]) {
        guard
            let id = duData[asInt: "id"],
            let status = duData[asString: "status"],
            let recipe = duData["recipe"] as? Recipe,
            let start = duData[asInt: "start"],
            let end = duData[asInt: "end"],
            let remainingTime = duData[asInt: "remainingTime"],
            let bulk = duData[asInt: "bulk"]
        else {
            return nil
        }
        
        self.id = id
        self.status = status
        self.recipe = recipe
        self.start = start
        self.end = end
        self.remainingTime = remainingTime
        self.bulk = bulk
    }
}
