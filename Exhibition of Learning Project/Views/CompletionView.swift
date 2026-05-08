//
//  CompletionView.swift
//  Exhibition of Learning Project
//
//  Created by Dittrich, Jan - Student on 5/7/26.
//


import SwiftUI

struct CompletionView: View {
    @ObservedObject var viewModel: EmailViewModel
    @State private var animateScore = false

    var percentage: Int {
        guard viewModel.totalAnswered > 0 else { return 0 }
        return Int((Double(viewModel.score) / Double(viewModel.totalAnswered)) * 100)
    }

    var performanceTitle: String {
        switch percentage {
        case 90...100: return "Security Expert! 🛡️"
        case 70...89: return "Well Done! 🎯"
        case 50...69: return "Getting There 📚"
        default: return "Keep Practicing 💪"
        }
    }

    var performanceColor: Color {
        switch percentage {
        case 90...100: return .green
        case 70...89: return .blue
        case 50...69: return .orange
        default: return .red
        }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                Spacer(minLength: 40)

                // Trophy / score
                VStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(performanceColor.opacity(0.12))
                            .frame(width: 120, height: 120)
                        Image(systemName: percentage >= 70 ? "shield.fill" : "shield.lefthalf.filled")
                            .font(.system(size: 56))
                            .foregroundStyle(performanceColor)
                    }
                    .scaleEffect(animateScore ? 1.0 : 0.6)
                    .opacity(animateScore ? 1.0 : 0)

                    Text(performanceTitle)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .opacity(animateScore ? 1.0 : 0)

                    HStack(spacing: 4) {
                        Text("\(viewModel.score)")
                            .font(.system(size: 64, weight: .bold, design: .rounded))
                            .foregroundStyle(performanceColor)
                        Text("/ \(viewModel.totalAnswered)")
                            .font(.system(size: 40, weight: .light, design: .rounded))
                            .foregroundStyle(.secondary)
                            .padding(.top, 18)
                    }
                    .opacity(animateScore ? 1.0 : 0)

                    Text("\(percentage)% correct")
                        .font(.title3)
                        .foregroundStyle(.secondary)
                        .opacity(animateScore ? 1.0 : 0)
                }

                Divider().padding(.horizontal, 60)

                // Tips summary
                VStack(alignment: .leading, spacing: 16) {
                    Text("Key Takeaways")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 40)

                    VStack(alignment: .leading, spacing: 12) {
                        TakeawayRow(icon: "envelope.badge.shield.half.filled", color: .red,
                            title: "Always check the sender domain",
                            detail: "Display names can be anything. The real email address (e.g. @apple-secure-id.com vs @apple.com) reveals the truth.")
                        TakeawayRow(icon: "clock.badge.exclamationmark", color: .orange,
                            title: "Urgency is a red flag",
                            detail: "Artificial deadlines ('act in 24 hours') are designed to bypass your critical thinking. Pause and verify.")
                        TakeawayRow(icon: "link", color: .blue,
                            title: "Inspect links before clicking",
                            detail: "Hover over links to see the real URL. Type known domains directly into your browser rather than clicking email links.")
                        TakeawayRow(icon: "phone.fill", color: .green,
                            title: "Verify out-of-band",
                            detail: "For sensitive requests (wire transfers, password resets), always verify through a separate, known channel — a direct phone call.")
                        TakeawayRow(icon: "person.2.slash", color: .purple,
                            title: "Secrecy is a manipulation tactic",
                            detail: "Legitimate requests don't require you to keep them secret from colleagues. Isolation is a key social engineering technique.")
                    }
                    .padding(.horizontal, 40)
                }
                .opacity(animateScore ? 1.0 : 0)

                // Restart button
                Button(action: viewModel.restart) {
                    HStack(spacing: 8) {
                        Image(systemName: "arrow.clockwise")
                            .fontWeight(.semibold)
                        Text("Train Again")
                            .fontWeight(.semibold)
                    }
                    .font(.headline)
                    .padding(.horizontal, 48)
                    .padding(.vertical, 16)
                    .background(Color.blue.gradient, in: RoundedRectangle(cornerRadius: 14))
                    .foregroundStyle(.white)
                }
                .buttonStyle(.plain)
                .opacity(animateScore ? 1.0 : 0)

                Spacer(minLength: 40)
            }
        }
        .background(Color(.systemGroupedBackground))
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.2)) {
                animateScore = true
            }
        }
    }
}

// MARK: - Takeaway Row
struct TakeawayRow: View {
    let icon: String
    let color: Color
    let title: String
    let detail: String

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(color.opacity(0.12))
                    .frame(width: 40, height: 40)
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundStyle(color)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Text(detail)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineSpacing(3)
            }
        }
    }
}