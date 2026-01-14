//
//  ContentView.swift
//  SQMAAssignments
//
//  Created by Cosmin Andrus on 14.01.2026.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    
    var body: some View {
        NavigationView {
            Form {
                Text(viewModel.subtitle)
                TextField(viewModel.nameLabel,
                          text: $viewModel.name)
                .textFieldStyle(.roundedBorder)
                if let feedback = viewModel.feedbackString {
                    Text(feedback)
                        .foregroundColor(viewModel.feedbackColor)
                }
                Button(viewModel.checkNameButtonText) {
                    viewModel.checkName()
                }.disabled(!viewModel.processButtonEnabled)
            }
            .listRowSeparator(.hidden)
            .navigationTitle(viewModel.title)
        }
    }
}

#Preview {
    ContentView()
}
