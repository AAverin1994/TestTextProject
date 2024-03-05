//
//  WordsCountCalculator.swift
//  TestTextProject
//
//  Created by Andrey on 05.03.2024.
//

import Foundation

struct RepeatedWordsCalculator {
    func calculate(text: String, minWordLenght: Int) -> [String: Int] {
        let wordsPattern = "\\b\\w{\(minWordLenght),}\\b"
        var matches: [String: Int] = [:]

        let range = NSRange(location: 0, length: text.utf16.count)
        guard let regex = try? NSRegularExpression(pattern: wordsPattern) else { return matches }

        regex.matches(in: text, range: range).forEach {
            guard let wordRange = Range($0.range, in: text) else { return }
            let word = String(text[wordRange])

            guard matches[word] == nil, let matchesCount = try? NSRegularExpression(pattern: word).matches(
                in: text,
                range: range
            ).count 
            else { return }
            
            matches[word] = matchesCount
        }

        return matches
    }
}
