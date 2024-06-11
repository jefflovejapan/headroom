//
//  ContentView.swift
//  FiltersNSliders
//
//  Created by Jeffrey Blagdon on 2024-06-11.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var viewModel: ViewModel
    @State private var errorMessage: String?
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            if let errorMessage {
                Text("Error: \(errorMessage)")
            }
        }
        .padding()
        .task {
            do {
                try await viewModel.load(path: "kmart_synthgroove", pathExtension: "mp3")
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }
}

#Preview {
    ContentView()
}
