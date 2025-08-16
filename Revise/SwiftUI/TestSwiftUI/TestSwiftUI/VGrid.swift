//
//  ContentView 2.swift
//  TestSwiftUI
//
//  Created by Dan Phi on 11/8/25.
//


import SwiftUI

struct ContentView: View {
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [.init(), .init()]) {
                ForEach(0..<10) { _ in
                    GroupBox(
                        label: Label("Heart Rate", systemImage: "heart.fill")
                            .foregroundColor(.red)
                    ) {
                        Text("Your hear rate is 90 BPM.")
                    }.groupBoxStyle(.automatic)
                }
            }.padding()
        }
    }
}

#Preview {
    ContentView()
}
