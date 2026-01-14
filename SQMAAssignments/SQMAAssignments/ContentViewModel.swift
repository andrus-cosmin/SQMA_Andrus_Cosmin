//
//  ContentViewModel.swift
//  SQMAAssignments
//
//  Created by Cosmin Andrus on 14.01.2026.
//

import Combine
import SwiftUI

enum FeedbackType {
    case cool
    case almostCool
    case notCool
}

final class ContentViewModel: ObservableObject {
    @Published var name: String = "" {
        didSet {
            feedbackType = nil
        }
    }
    @Published var feedbackType: FeedbackType?
    
    @Published var title: String
    @Published var subtitle: String
    @Published var nameLabel: String
    @Published var checkNameButtonText: String
    
    init () {
        self.title = "Name Challenge"
        self.subtitle = "Type a name and see if it's cool!"
        self.nameLabel = "Type a name"
        self.checkNameButtonText = "Check Name"
    }
    var processButtonEnabled: Bool {
        !name.isEmpty
    }
    
    var feedbackString: String? {
        guard let feedbackType else { return nil }
        switch feedbackType {
        case .cool:
            return "This is a cool name!"
        case .almostCool:
            return "Not bad, but not cool name either."
        case .notCool:
            return "Keep trying, you're getting there!"
        }
    }
    
    var feedbackColor: Color {
        guard let feedbackType else { return .white }
        switch feedbackType {
        case .cool:
            return .green
        case .almostCool:
            return .orange
        case .notCool:
            return .red
        }
    }
    
    func checkName() {
        let vowelsCount = countVowels(in: name.lowercased())
        let notVowelsCount = name.count - vowelsCount
        if vowelsCount == notVowelsCount {
            feedbackType = .almostCool
        } else if vowelsCount > notVowelsCount {
            feedbackType = .cool
        } else {
            feedbackType = .notCool
        }
    }
    
    private func countVowels(in word: String) -> Int {
        let vowels: Set<Character> = ["a", "e", "i", "o", "u", "y"]
        return word.lowercased().filter { vowels.contains($0) }.count
    }
}
