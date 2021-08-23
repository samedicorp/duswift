//
//  File.swift
//  File
//
//  Created by Sam Deane on 20/08/2021.
//

import Foundation

public struct LogDataParser {
    let objectPattern = try! NSRegularExpression(pattern: #"^(\w+):\[(.*)\]"#, options: [])
    let datePattern = try! NSRegularExpression(pattern: #"^@\((\d+)\) (\d\d\d\d-\d\d-\d\d \d\d:\d\d:\d\d)"#, options: [])
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    public init() {
    }
    
    func parseValue(_ string: String.SubSequence, skipEmptyString: Bool = false) -> Any? {
        let trimmed = string.trimmingCharacters(in: .whitespaces)
        let range = NSRange(location: 0, length: trimmed.count)
        if let match = objectPattern.firstMatch(in: trimmed, options: [], range: range) {
            let kind = trimmed[match.range(at: 1)]
            let values = trimmed[match.range(at: 2)]
            if values.contains("=") {
                return parseObject(kind: kind, values: values)
            } else {
                let list = parseList(values: values)
                return ["kind": kind, "values": list]
            }

        } else if (trimmed.first == "[") && (trimmed.last == "]") {
            return parseList(values: trimmed[trimmed.index(after: trimmed.startIndex)..<trimmed.endIndex])
            
        } else if let match = datePattern.firstMatch(in: trimmed, options: [], range: range) {
            let dateString = String(trimmed[match.range(at: 2)])
            let date = dateFormatter.date(from: dateString)
            return date
            
        } else if let int = Int(trimmed) {
            return int
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

    func parseObject(kind: String.SubSequence, values: String.SubSequence) -> [String:Any] {
        var object: [String:Any] = [ "kind" : String(kind)]
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

        return object
    }

    public func parse(_ string: String) -> Any? {
        var cleaned = string.replacingOccurrences(of: ", ]", with: "], ")
        return parseValue(cleaned[cleaned.startIndex..<cleaned.endIndex])
    }
}
