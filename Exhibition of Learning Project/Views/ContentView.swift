//
//  ContentView.swift
//  Exhibition of Learning Project
//
//  Created by Dittrich, Jan - Student on 5/4/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = EmailViewModel()
    
    var body: some View {
        ZStack {
            if viewModel.showCompletionScreen {
                CompletionView(viewModel: viewModel)
                    .transition(.asymmetric(
                        insertion: .opacity.combined(with: .scale(scale: 0.95)),
                        removal: .opacity
                    ))
            } else {
                MailClientLayout(viewModel: viewModel)
                    .transition(.opacity)
            }
        }
        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: viewModel.showCompletionScreen)
    }
}

// MARK: - Mail Client Layout
struct MailClientLayout: View {
    @ObservedObject var viewModel: EmailViewModel
    
    var body: some View {
        NavigationSplitView(columnVisibility: .constant(.all)) {
            SidebarView(viewModel: viewModel)
                .navigationSplitViewColumnWidth(min: 260, ideal: 300, max: 340)
        } detail: {
            if let email = viewModel.currentEmail {
                EmailDetailView(email: email, viewModel: viewModel)
            } else {
                EmptyEmailView()
            }
        }
        .navigationSplitViewStyle(.balanced)
    }
}
