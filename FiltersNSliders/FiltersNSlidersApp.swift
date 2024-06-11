//
//  FiltersNSlidersApp.swift
//  FiltersNSliders
//
//  Created by Jeffrey Blagdon on 2024-06-11.
//

import SwiftUI

@main
struct FiltersNSlidersApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .environmentObject(ViewModel())
    }
}
