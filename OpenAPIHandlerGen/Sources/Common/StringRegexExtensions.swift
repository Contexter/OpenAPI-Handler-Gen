// File: OpenAPIHandlerGen/Sources/Common/StringRegexExtensions.swift

import Foundation

extension String {
    func matches(for regex: String) -> [[String]] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: self, range: NSRange(self.startIndex..., in: self))
            return results.map { match in
                (0..<match.numberOfRanges).compactMap {
                    let range = Range(match.range(at: $0), in: self)
                    return range.map { String(self[$0]) }
                }
            }
        } catch {
            print("Invalid regex: \(error)")
            return []
        }
    }
}
