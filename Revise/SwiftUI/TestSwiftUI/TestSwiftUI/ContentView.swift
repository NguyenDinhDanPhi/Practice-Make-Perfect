//
//  ContentView.swift
//  TestSwiftUI
//
//  Created by Dan Phi on 11/8/25.
//

import SwiftUI

import SwiftUI

struct ZoomDemo: View {
    @Namespace private var hero

    var body: some View {
        NavigationStack {
            List(0..<20, id: \.self) { i in
                NavigationLink(value: i) {
                    HStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.blue)
                            .frame(width: 44, height: 44)
                            .matchedTransitionSource(id: "tile-\(i)", in: hero)
                        Text("Item \(i)")
                    }
                }
            }
            .navigationDestination(for: Int.self) { i in
                DetailView(i: i, hero: hero)
                    .navigationTransition(.zoom(sourceID: "tile-\(i)", in: hero))
            }
            .navigationTitle("Zoom Transition")
        }
    }
}

private struct DetailView: View {
    let i: Int
    let hero: Namespace.ID
    var body: some View {
        VStack(spacing: 16) {
            RoundedRectangle(cornerRadius: 16)
                .fill(.blue)
                .matchedTransitionSource(id: "tile-\(i)", in: hero)
                .frame(height: 220)
            Text("Detail for item \(i)")
                .font(.title2)
        }
        .padding()
    }
}
#Preview(body: {
    ZoomDemo()
})
