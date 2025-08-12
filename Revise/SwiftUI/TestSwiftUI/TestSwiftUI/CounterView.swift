//
//  CounterView.swift
//  TestSwiftUI
//
//  Created by Dan Phi on 11/8/25.
//


import SwiftUI

struct CounterView: View {
    @Binding var count: Int
    var body: some View {
        VStack(spacing: 12) {
            Text("Count: \(count)").font(.title2)
            HStack {
                Button("−") { count -= 1 }
                Button("+") { count += 1 }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}
#Preview {
    @Previewable @State var value = 3
    CounterView(count: $value)
        .previewDisplayName("Counter preview")
}
