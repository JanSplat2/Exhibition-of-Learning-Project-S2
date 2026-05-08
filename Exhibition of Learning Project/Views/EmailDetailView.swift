//
//  EmailDetailView.swift
//  Exhibition of Learning Project
//
//  Created by Dittrich, Jan - Student on 5/7/26.
//


import SwiftUI

struct EmailDetailView: View {
    let email: PhishingEmail
    @ObservedObject var viewModel: EmailViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {

                // Email Header
                EmailHeaderSection(email: email)

                Divider().padding(.horizontal, 24)

                // Email Body
                EmailBodySection(email: email)

                Divider().padding(.horizontal, 24).padding(.top, 8)

                // Decision Buttons
                if viewModel.guessResult == .unanswered {
                    DecisionSection(viewModel: viewModel)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                }

                // Feedback Panel
                if viewModel.showFeedback {
                    FeedbackPanel(
                        email: email,
                        isCorrect: viewModel.guessResult == .correct,
                        userGuessedPhishing: viewModel.userGuessedPhishing,
                        onNext: { viewModel.nextEmail() }
                    )
                    .transition(.asymmetric(
                        insertion: .opacity.combined(with: .move(edge: .bottom)),
                        removal: .opacity
                    ))
                    .padding(.horizontal, 24)
                    .padding(.vertical, 20)
                }

                Spacer(minLength: 40)
            }
        }
        .background(Color(.systemBackground))
        .navigationTitle("")
        .toolbar(.hidden, for: .navigationBar)
        .animation(.spring(response: 0.4, dampingFraction: 0.75), value: viewModel.showFeedback)
        .animation(.easeInOut(duration: 0.2), value: viewModel.guessResult)
        .id(email.id) // Force redraw on email change
    }
}

// MARK: - Email Header Section
struct EmailHeaderSection: View {
    let email: PhishingEmail

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Subject
            Text(email.subject)
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.top, 24)

            // Sender info row
            HStack(alignment: .top, spacing: 12) {
                // Avatar
                ZStack {
                    Circle()
                        .fill(avatarColor(email.senderAvatarColor))
                        .frame(width: 46, height: 46)
                    Text(email.senderInitials)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.white)
                }

                VStack(alignment: .leading, spacing: 3) {
                    HStack(spacing: 6) {
                        Text(email.sender)
                            .font(.subheadline)
                            .fontWeight(.semibold)

                        // Difficulty badge
                        DifficultyBadge(difficulty: email.difficulty)
                    }

                    // Sender email — the key red flag area
                    HStack(spacing: 4) {
                        Text("From:")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text(email.senderEmail)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }

                    HStack(spacing: 4) {
                        Text("To:")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text("me")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text(email.date)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 20)
    }

    func avatarColor(_ name: String) -> Color {
        switch name {
        case "gray": return Color(.systemGray)
        case "blue": return Color.blue
        case "yellow": return Color.orange
        case "indigo": return Color.indigo
        case "purple": return Color.purple
        case "green": return Color.green
        case "black": return Color(.darkGray)
        default: return Color.gray
        }
    }
}

// MARK: - Difficulty Badge
struct DifficultyBadge: View {
    let difficulty: PhishingEmail.Difficulty

    var body: some View {
        Text(difficulty.rawValue)
            .font(.caption2)
            .fontWeight(.semibold)
            .padding(.horizontal, 7)
            .padding(.vertical, 2)
            .background(badgeColor.opacity(0.15), in: Capsule())
            .foregroundStyle(badgeColor)
    }

    var badgeColor: Color {
        switch difficulty {
        case .easy: return .green
        case .medium: return .orange
        case .hard: return .red
        }
    }
}

// MARK: - Email Body Section
struct EmailBodySection: View {
    let email: PhishingEmail

    var body: some View {
        let formattedText = parseMarkdown(email.body)
        Text(formattedText)
            .font(.body)
            .lineSpacing(6)
            .padding(.horizontal, 24)
            .padding(.vertical, 20)
    }

    func parseMarkdown(_ text: String) -> AttributedString {
        (try? AttributedString(markdown: text)) ?? AttributedString(text)
    }
}

// MARK: - Decision Section
struct DecisionSection: View {
    @ObservedObject var viewModel: EmailViewModel

    var body: some View {
        VStack(spacing: 12) {
            Text("Is this email a phishing attempt?")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .padding(.top, 20)

            HStack(spacing: 16) {
                // Phishing button
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        viewModel.submitGuess(isPhishing: true)
                    }
                } label: {
                    Label("This is Phishing", systemImage: "exclamationmark.shield.fill")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.red.gradient, in: RoundedRectangle(cornerRadius: 14))
                        .foregroundStyle(.white)
                }
                .buttonStyle(.plain)
                .scaleEffect(1.0)

                // Legitimate button
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        viewModel.submitGuess(isPhishing: false)
                    }
                } label: {
                    Label("This is Legitimate", systemImage: "checkmark.seal.fill")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.green.gradient, in: RoundedRectangle(cornerRadius: 14))
                        .foregroundStyle(.white)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 20)
        }
    }
}

// MARK: - Empty Email View
struct EmptyEmailView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "envelope.open")
                .font(.system(size: 64))
                .foregroundStyle(.quaternary)
            Text("Select an email to review")
                .font(.title3)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}