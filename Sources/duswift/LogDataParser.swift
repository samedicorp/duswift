//
//  File.swift
//  File
//
//  Created by Sam Deane on 20/08/2021.
//

import Foundation

public protocol DUDataType {
    init?(duData: [String:Any])
}

public struct LogDataParser {
    let classes: [String:DUDataType.Type]
    let objectPattern = try! NSRegularExpression(pattern: #"^(\w+):\[(.*)\]"#, options: [])
    let datePattern = try! NSRegularExpression(pattern: #"^@\((\d+)\) (\d\d\d\d-\d\d-\d\d \d\d:\d\d:\d\d)"#, options: [])
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    public init(map: DUTypeMap = DUTypeMap.default) {
        self.classes = map.classes
    }
    
    func unmapped(kind: String, object: [String:Any]) -> Any {
        if let mapping = classes[kind] {
            if let object = mapping.init(duData: object) {
                return object
            } else {
                print("Failed to init mapped type \(kind)")
            }
        }

        return UnmappedType(kind: kind, data: object)
    }
    
    func parseValue(_ string: String.SubSequence, skipEmptyString: Bool = false) -> Any? {
        let trimmed = string.trimmingCharacters(in: .whitespaces)
        let range = NSRange(location: 0, length: trimmed.count)
        if let match = objectPattern.firstMatch(in: trimmed, options: [], range: range) {
            let kind = String(trimmed[match.range(at: 1)])
            let values = trimmed[match.range(at: 2)]
            if values.contains("=") {
                return parseObject(kind: kind, values: values)
            } else {
                let list = parseList(values: values)
                return unmapped(kind: kind, object: ["values": list])
            }

        } else if (trimmed.first == "[") && (trimmed.last == "]") {
            return parseList(values: trimmed[trimmed.index(after: trimmed.startIndex)..<trimmed.index(before: trimmed.endIndex)])
            
        } else if let match = datePattern.firstMatch(in: trimmed, options: [], range: range) {
            let dateString = String(trimmed[match.range(at: 2)])
            let date = dateFormatter.date(from: dateString)
            return date
            
        } else if let int = Int(trimmed) {
            return int
        } else if let double = Double(trimmed) {
            return double
        } else if trimmed.isEmpty && skipEmptyString {
            return nil
        } else {
            return trimmed
        }
    }

    func parsePair(_ string: String.SubSequence, index: Int, skipEmptyString: Bool = false) -> (String, Any)? {
        if let index = string.firstIndex(of: "=") {
            let key = String(string[..<index].trimmingCharacters(in: .whitespaces))
            let value = string[string.index(after: index)...]
            return (key, parseValue(value) ?? "")
        } else if let value = parseValue(string, skipEmptyString: skipEmptyString) {
            return ("#\(index)", value)
        } else {
            return nil
        }
    }

    func parseList(values: String.SubSequence) -> [Any] {
        var list: [Any] = []
        
        var nesting = 0

        var start = values.startIndex
        var index = start
        while index < values.endIndex {
            let char = values[index]
            
            if char == "[" {
                nesting += 1
            } else if char == "]" {
                nesting -= 1
            } else if (nesting == 0) && (char == ",") {
                if let value = parseValue(values[start ..< index]) {
                    list.append(value)
                    start = values.index(after: index)
                }
            }

            index = values.index(after: index)
        }

        if let value = parseValue(values[start ..< index], skipEmptyString: true) {
            list.append(value)
        }

        return list
    }

    func parseObject(kind: String, values: String.SubSequence) -> Any {
        var object: [String:Any] = [:]
        var nesting = 0

        var start = values.startIndex
        var index = start
        while index < values.endIndex {
            let char = values[index]
            
            if char == "[" {
                nesting += 1
            } else if char == "]" {
                nesting -= 1
                if nesting == 0 {
                    let next = values.index(after: index)
                    if let pair = parsePair(values[start ... index], index: object.count) {
                        object[pair.0] = pair.1
                        if (next < values.endIndex) && values[next] == "," {
                            index = next
                        }
                        start = values.index(after: index)
                    }
                }
            } else if (nesting == 0) && (char == ",") {
                if let pair = parsePair(values[start ..< index], index: object.count) {
                    object[pair.0] = pair.1
                    start = values.index(after: index)
                }
            }

            index = values.index(after: index)
        }

        if let pair = parsePair(values[start ..< index], index: object.count, skipEmptyString: true) {
            object[pair.0] = pair.1
            start = index
        }

        return unmapped(kind: kind, object: object)
    }

    public func parse(_ string: String) -> Any? {
        return parseValue(string[string.startIndex..<string.endIndex])
    }
}
