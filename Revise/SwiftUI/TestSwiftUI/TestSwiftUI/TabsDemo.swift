//
//  TabsDemo.swift
//  TestSwiftUI
//
//  Created by Dan Phi on 11/8/25.
//

import SwiftUI

struct TabsDemo: View {
    @State private var selection = 0
    @State private var customization = TabViewCustomization()

    var body: some View {
        TabView(selection: $selection) {
            Text("Home")
                .tabItem { Label("Home", systemImage: "house") }
                .tag(0)

            Text("Messages")
                .tabItem { Label("Messages", systemImage: "bubble.left.and.bubble.right") }
                .tag(1)

            Text("Settings")
                .tabItem { Label("Settings", systemImage: "gearshape") }
                .tag(2)
        }
        .tabViewStyle(.sidebarAdaptable)              // iPad/macOS có thể chuyển Sidebar
        .tabViewCustomization($customization)        // Binding TabViewCustomization, không phải Binding<Int>
    }
}


private struct SettingsView: View {
    var body: some View {
        Form {
            Toggle("Enable Feature X", isOn: .constant(true))
            Toggle("Enable Feature Y", isOn: .constant(false))
        }
    }
}

#Preview {
    TabsDemo()
}
