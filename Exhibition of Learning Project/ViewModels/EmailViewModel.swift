//
//  GuessResult.swift
//  Exhibition of Learning Project
//
//  Created by Dittrich, Jan - Student on 5/7/26.
//


import SwiftUI
import Combine

// MARK: - Game State
enum GuessResult {
    case correct, incorrect, unanswered
}

// MARK: - Email View Model
class EmailViewModel: ObservableObject {
    @Published var emails: [PhishingEmail] = sampleEmails.shuffled()
    @Published var currentIndex: Int = 0
    @Published var guessResult: GuessResult = .unanswered
    @Published var showFeedback: Bool = false
    @Published var score: Int = 0
    @Published var totalAnswered: Int = 0
    @Published var showCompletionScreen: Bool = false
    @Published var userGuessedPhishing: Bool = false

    var currentEmail: PhishingEmail? {
        guard currentIndex < emails.count else { return nil }
        return emails[currentIndex]
    }

    var progress: Double {
        guard !emails.isEmpty else { return 0 }
        return Double(currentIndex) / Double(emails.count)
    }

    func submitGuess(isPhishing: Bool) {
        guard let email = currentEmail, guessResult == .unanswered else { return }
        userGuessedPhishing = isPhishing
        let correct = isPhishing == email.isPhishing
        guessResult = correct ? .correct : .incorrect
        totalAnswered += 1
        if correct { score += 1 }
        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
            showFeedback = true
        }
    }

    func nextEmail() {
        withAnimation(.easeInOut(duration: 0.3)) {
            showFeedback = false
            guessResult = .unanswered
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            if self.currentIndex + 1 >= self.emails.count {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
                    self.showCompletionScreen = true
                }
            } else {
                withAnimation(.easeInOut(duration: 0.25)) {
                    self.currentIndex += 1
                }
            }
        }
    }

    func restart() {
        emails = sampleEmails.shuffled()
        currentIndex = 0
        guessResult = .unanswered
        showFeedback = false
        score = 0
        totalAnswered = 0
        showCompletionScreen = false
    }
}