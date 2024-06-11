//
//  ContentView.swift
//  FiltersNSliders
//
//  Created by Jeffrey Blagdon on 2024-06-11.
//

import SwiftUI
import Charts

struct ContentView: View {
    @EnvironmentObject private var viewModel: ViewModel
    @State private var errorMessage: String?
    var body: some View {
        VStack {
            coolChart()
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
    
    @MainActor
    private func coolChart() -> some View {
        ChartView()
    }
}

#Preview {
    ContentView()
}
