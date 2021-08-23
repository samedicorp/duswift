// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 05/05/2021.
//  All code (c) 2021 - present day, Elegant Chaos.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import XCTest
import XCTestExtensions
import ElegantStrings
import Files

@testable import duswift

let bigLog = URL(fileURLWithPath: "/Users/sam/Dropbox/Games/Dual Universe/Logs/log_2021-08-17_18h51m44s.xml")
let exampleLog = URL(fileURLWithPath: "/Users/sam/Developer/Projects/duswift/Sources/duswift/Resources/example-log.xml")
let smallLog = URL(fileURLWithPath: "/Users/sam/Dropbox/Games/Dual Universe/Logs/log_2021-08-17_18h51m44s.xml")

final class duswiftTests: XCTestCase {
    func testMarketParser() {
        let sample = "MarketInfo:[marketId = 1662, relativeLocation = RelativeLocation:[constructId = 0, position = Vec3:[-13240359.185984, 55770780.524610, 523150.759589], rotation = Quat:[0.000394, -0.065151, -0.651803, 0.755584]], position = Vec3:[59884.890559, 71046.571866, 122843.964022], parentConstruct = 4, name = Market Talemai 6, creatorId = EntityId:[playerId = 2, organizationId = 0], creatorName = Aphelia, creationDate = @(1597790543741) 2020-08-18 23:42:23, capacity = 10000, valueTax = 0.01, dailyStorageFee = 2, orderFee = 1000, allowedItemTypes = [3480514136, 1235359659, ]updateCooldown = 300]"
        let parser = LogDataParser()
        let market = parser.parse(sample) as! MarketInfo
        XCTAssertEqual(market.id, 1662)
        XCTAssertEqual(market.name, "Market Talemai 6")
    }
    
    func testPropertiesParser() {
        let parser = LogDataParser()
        
        XCTAssertEqual(parser.parseValue("1") as? Int, 1)
        XCTAssertEqual(parser.parseValue("Test") as? String, "Test")
        
        let parsed = parser.parseValue("Class:[name = Blah, id = 123]") as! UnmappedType
        XCTAssertEqual(parsed.kind, "Class")
        XCTAssertEqual(parsed.data["name"] as? String, "Blah")
        XCTAssertEqual(parsed.data["id"] as? Int, 123)
    }
    
    func testConstructParser() {
        let source = "ConstructInfo:[rData = ConstructRelativeData:[constructId = 3444585, parentId = 2, position = Vec3:[212943.406548, 121780.119505, 226436.516359], rotation = Quat:[0.287642, 0.196889, 0.709191, 0.612817], geometry = ConstructGeometry:[size = 128, kind = Octree, voxelLod0 = 3, radius = UNSET, minRadius = UNSET, maxRadius = UNSET, ], name = Chaos Towers, isStatic = true], mutableData = ConstructMutableData:[ownerId = EntityId:[playerId = 0, organizationId = 3706], keyExpiration = @(0) 1970-01-01 00:00:00, pvpTimerExpiration = @(0) 1970-01-01 00:00:00, repairedBy = UNSET, shieldHpRatio = UNSET, meshURL = https://d3im1kyg9fdjv4.cloudfront.net/public/voxels/constructs/3444585/mesh.glb?async=1&version=437, meshObjectURL = https://d3im1kyg9fdjv4.cloudfront.net/public/voxels/constructs/3444585/meshData?async=1&version=437, ], creatorId = EntityId:[playerId = 0, organizationId = 3706], kind = STATIC, blueprintId = UNSET, planetProperties = UNSET, pipelineURL = UNSET, pipeline = UNSET, ]"
        let parser = LogDataParser()
        
        let construct = parser.parse(source) as! ConstructInfo
        XCTAssertEqual(construct.rData.name, "Chaos Towers")
        XCTAssertEqual(construct.rData.constructId, 3444585)
    }
}
