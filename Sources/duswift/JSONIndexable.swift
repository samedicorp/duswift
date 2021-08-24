// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 24/08/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Files
import Foundation

protocol JSONIndexable {
    var jsonID: Int { get }
    var jsonName: String { get }
}

extension Array where Element: JSONIndexable, Element: Codable {
    func save(to url: URL, as name: String) {
        if FileManager.default.fileExists(atURL: url) {
            do {
                let encoder = JSONEncoder()

                var names: [String:Int] = [:]
                var ids: [Int:String] = [:]
                for item in self {
                    let id = item.jsonID
                    let name = item.jsonName
                    names[name] = id
                    ids[id] = name
                }
                encoder.outputFormatting = []
                let encodedCompact = try encoder.encode(self)
                try encodedCompact.write(to: url.appendingPathComponent("compact.json"))
                let encodedNames = try encoder.encode(names)
                try encodedNames.write(to: url.appendingPathComponent("names.json"))
                let encodedIds = try encoder.encode(ids)
                try encodedIds.write(to: url.appendingPathComponent("ids.json"))
                encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
                let encodedReadable = try encoder.encode(self)
                try encodedReadable.write(to: url.appendingPathComponent("\(name).json"))
            } catch {
                print("Couldn't save \(name) items.")
            }
        }
    }
}

extension Dictionary where Value: JSONIndexable, Key: Codable, Value: Codable {
    func save(to url: URL, as name: String) {
        if FileManager.default.fileExists(atURL: url) {
            do {
                print("Exporting \(name)")
                let encoder = JSONEncoder()

                var names: [String:Int] = [:]
                var ids: [Int:String] = [:]
                for item in self.values {
                    let id = item.jsonID
                    let name = item.jsonName
                    names[name] = id
                    ids[id] = name
                }
                encoder.outputFormatting = []
                let encodedCompact = try encoder.encode(self)
                try encodedCompact.write(to: url.appendingPathComponent("compact.json"))
                let encodedNames = try encoder.encode(names)
                try encodedNames.write(to: url.appendingPathComponent("names.json"))
                let encodedIds = try encoder.encode(ids)
                try encodedIds.write(to: url.appendingPathComponent("ids.json"))
                encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
                let encodedReadable = try encoder.encode(self)
                try encodedReadable.write(to: url.appendingPathComponent("\(name).json"))
            } catch {
                print("Couldn't save \(name) items.")
            }
        }
    }
}
