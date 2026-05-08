//
//  FeedbackPanel.swift
//  Exhibition of Learning Project
//
//  Created by Dittrich, Jan - Student on 5/7/26.
//


import SwiftUI

struct FeedbackPanel: View {
    let email: PhishingEmail
    let isCorrect: Bool
    let userGuessedPhishing: Bool
    let onNext: () -> Void
    
    @State private var expandedTactic = true
    @State private var expandedRedFlags = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            // Result Banner
            ResultBanner(
                isCorrect: isCorrect,
                email: email,
                userGuessedPhishing: userGuessedPhishing
            )
            
            // Tactic Section
            DisclosureGroupPanel(
                title: email.isPhishing ? "Social Engineering Tactic Used" : "Why This Email is Legitimate",
                icon: email.tactic.icon,
                iconColor: tacticColor(email.tactic),
                isExpanded: $expandedTactic
            ) {
                VStack(alignment: .leading, spacing: 12) {
                    if email.isPhishing {
                        TacticBadge(tactic: email.tactic)
                    }
                    let explanationAttr = (try? AttributedString(markdown: email.tacticExplanation)) ?? AttributedString(email.tacticExplanation)
                    Text(explanationAttr)
                        .font(.subheadline)
                        .lineSpacing(4)
                        .foregroundStyle(.primary)
                }
                .padding(.top, 4)
            }
            
            // Red Flags Section (only for phishing)
            if email.isPhishing && !email.redFlags.isEmpty {
                Divider().padding(.vertical, 4)
                
                DisclosureGroupPanel(
                    title: "Red Flags in This Email (\(email.redFlags.count))",
                    icon: "flag.fill",
                    iconColor: .red,
                    isExpanded: $expandedRedFlags
                ) {
                    VStack(alignment: .leading, spacing: 14) {
                        ForEach(email.redFlags) { flag in
                            RedFlagRow(flag: flag)
                        }
                    }
                    .padding(.top, 4)
                }
            }
            
            // Next Button
            Button(action: onNext) {
                HStack {
                    Text("Next Email")
                        .fontWeight(.semibold)
                    Image(systemName: "arrow.right")
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Color.blue.gradient, in: RoundedRectangle(cornerRadius: 13))
                .foregroundStyle(.white)
            }
            .buttonStyle(.plain)
            .padding(.top, 16)
        }
        .padding(20)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 18))
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .strokeBorder(isCorrect ? Color.green.opacity(0.4) : Color.red.opacity(0.4), lineWidth: 1.5)
        )
        .shadow(color: .black.opacity(0.06), radius: 12, y: 4)
    }
    
    func tacticColor(_ tactic: SocialEngineeringTactic) -> Color {
        switch tactic {
        case .urgency: return .orange
        case .impersonation: return .purple
        case .curiosity: return .blue
        case .authority: return .indigo
        case .fear: return .red
        case .reward: return .yellow
        case .pretexting: return .teal
        case .none: return .green
        }
    }
}

// MARK: - Result Banner
struct ResultBanner: View {
    let isCorrect: Bool
    let email: PhishingEmail
    let userGuessedPhishing: Bool
    
    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(isCorrect ? Color.green.opacity(0.15) : Color.red.opacity(0.15))
                    .frame(width: 52, height: 52)
                Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .font(.system(size: 30))
                    .foregroundStyle(isCorrect ? .green : .red)
            }
            VStack(alignment: .leading, spacing: 3) {
                Text(isCorrect ? "Correct! 🎉" : "Incorrect")
                    .font(.headline)
                    .foregroundStyle(isCorrect ? .green : .red)
                Text(resultSubtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
            Spacer()
        }
        .padding(.bottom, 16)
    }
    
    var resultSubtitle: String {
        if isCorrect {
            return email.isPhishing
            ? "You correctly identified this as a phishing email."
            : "You correctly identified this as a legitimate email."
        } else {
            return email.isPhishing
            ? "This was actually a phishing attempt. Here's what to look for:"
            : "This was actually a legitimate email. Here's why:"
        }
    }
}

// MARK: - Tactic Badge
struct TacticBadge: View {
    let tactic: SocialEngineeringTactic
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: tactic.icon)
                .font(.subheadline)
            Text(tactic.rawValue)
                .font(.subheadline)
                .fontWeight(.semibold)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 7)
        .background(badgeColor.opacity(0.12), in: RoundedRectangle(cornerRadius: 10))
        .foregroundStyle(badgeColor)
    }
    
    var badgeColor: Color {
        switch tactic {
        case .urgency: return .orange
        case .impersonation: return .purple
        case .curiosity: return .blue
        case .authority: return .indigo
        case .fear: return .red
        case .reward: return .yellow
        case .pretexting: return .teal
        case .none: return .green
        }
    }
}

// MARK: - Red Flag Row
struct RedFlagRow: View {
    let flag: RedFlag
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.subheadline)
                .foregroundStyle(.orange)
                .frame(width: 20, height: 20)
                .padding(.top, 1)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(flag.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Text(flag.description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineSpacing(3)
            }
        }
    }
}

// MARK: - Disclosure Group Panel
struct DisclosureGroupPanel<Content: View>: View {
    let title: String
    let icon: String
    let iconColor: Color
    @Binding var isExpanded: Bool
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                    isExpanded.toggle()
                }
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: icon)
                        .font(.subheadline)
                        .foregroundStyle(iconColor)
                        .frame(width: 22)
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .rotationEffect(.degrees(isExpanded ? 90 : 0))
                        .animation(.spring(response: 0.35), value: isExpanded)
                }
                .padding(.vertical, 8)
            }
            .buttonStyle(.plain)
            
            if isExpanded {
                content()
                    .padding(.leading, 32)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }
}

