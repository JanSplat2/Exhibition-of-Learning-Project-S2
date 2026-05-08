//
//  SidebarView.swift
//  Exhibition of Learning Project
//
//  Created by Dittrich, Jan - Student on 5/7/26.
//


import SwiftUI

struct SidebarView: View {
    @ObservedObject var viewModel: EmailViewModel

    var body: some View {
        VStack(spacing: 0) {
            // Header
            SidebarHeaderView(viewModel: viewModel)

            Divider()

            // Email List
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(Array(viewModel.emails.enumerated()), id: \.element.id) { index, email in
                        EmailRowView(
                            email: email,
                            isSelected: index == viewModel.currentIndex,
                            isAnswered: index < viewModel.currentIndex,
                            index: index
                        )
                        .onTapGesture {
                            // Only allow navigating to already-answered or current email
                            if index <= viewModel.currentIndex {
                                viewModel.currentIndex = index
                                viewModel.guessResult = index < viewModel.totalAnswered ? .correct : .unanswered
                                viewModel.showFeedback = index < viewModel.totalAnswered
                            }
                        }
                        Divider().padding(.leading, 68)
                    }
                }
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("")
        .toolbar(.hidden, for: .navigationBar)
    }
}

// MARK: - Sidebar Header
struct SidebarHeaderView: View {
    @ObservedObject var viewModel: EmailViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Image(systemName: "envelope.fill")
                    .foregroundStyle(.blue)
                    .font(.title3)
                Text("Phishing Trainer")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
                // Score badge
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .font(.caption2)
                        .foregroundStyle(.yellow)
                    Text("\(viewModel.score)/\(viewModel.totalAnswered)")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(.quaternary, in: Capsule())
            }

            // Progress bar
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text("Progress")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text("\(viewModel.currentIndex)/\(viewModel.emails.count)")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 3)
                            .fill(Color(.systemFill))
                            .frame(height: 6)
                        RoundedRectangle(cornerRadius: 3)
                            .fill(Color.blue.gradient)
                            .frame(width: geo.size.width * viewModel.progress, height: 6)
                            .animation(.spring(response: 0.4), value: viewModel.progress)
                    }
                }
                .frame(height: 6)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(.systemGroupedBackground))
    }
}

// MARK: - Email Row
struct EmailRowView: View {
    let email: PhishingEmail
    let isSelected: Bool
    let isAnswered: Bool
    let index: Int

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Avatar
            ZStack {
                Circle()
                    .fill(avatarColor(email.senderAvatarColor))
                    .frame(width: 42, height: 42)
                Text(email.senderInitials)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.white)
            }
            .overlay(alignment: .bottomTrailing) {
                if isAnswered {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 14))
                        .foregroundStyle(.white, Color.green)
                        .background(Circle().fill(.white).frame(width: 12, height: 12))
                }
            }

            VStack(alignment: .leading, spacing: 3) {
                HStack {
                    Text(email.sender)
                        .font(.subheadline)
                        .fontWeight(isAnswered ? .regular : .semibold)
                        .lineLimit(1)
                    Spacer()
                    Text(email.date)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Text(email.subject)
                    .font(.subheadline)
                    .lineLimit(1)
                    .foregroundStyle(isAnswered ? .secondary : .primary)
                Text(email.preview)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(isSelected ? Color(.systemBlue).opacity(0.12) : Color.clear)
        .overlay(alignment: .leading) {
            if !isAnswered && index >= 0 {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 8, height: 8)
                    .offset(x: 3)
            }
        }
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