//
//  File.swift
//  File
//
//  Created by Sam Deane on 20/08/2021.
//

import Foundation

struct LogDataParser {
    func parseValue(_ string: String.SubSequence) -> Any? {
        guard let index = string.firstIndex(of: ":") else {
            let trimmed = string.trimmingCharacters(in: .whitespaces)
            if let int = Int(trimmed) {
                return int
            } else {
                return trimmed
            }
        }
        
        return parseObject(kind: string[..<index], string: string[string.index(after: index)...])
    }

    func parsePair(_ string: String.SubSequence) -> (String, Any)? {
        guard let index = string.firstIndex(of: "=") else { return nil }
        
        let key = String(string[..<index].trimmingCharacters(in: .whitespaces))
        let value = string[string.index(after: index)...]
        return (key, parseValue(value) ?? "")
    }
    
    func parseObject(kind: String.SubSequence, string: String.SubSequence) -> [String:Any] {
        var object: [String:Any] = [ "kind" : String(kind)]
        
        var nesting = 0

        var start = string.startIndex
        var last = string.index(before: string.endIndex)

        assert(string[start] == "[")
        assert(string[last] == "]")

        start = string.index(after: start)

        var index = start
        while index < string.endIndex {
            let char = string[index]
            
            if char == "[" {
                nesting += 1
            } else if char == "]" {
                nesting -= 1
            } else if (nesting == 0) && ((char == ",") || index == last) {
                if let pair = parsePair(string[start ..< index]) {
                    object[pair.0] = pair.1
                    start = string.index(after: index)
                }
            }

            index = string.index(after: index)
        }

        if let pair = parsePair(string[start ..< index]) {
            object[pair.0] = pair.1
            start = index
        }

        return object
    }
    
    func parse(_ string: String) -> Any? {
        return parseValue(string[string.startIndex..<string.endIndex])
    }
}
