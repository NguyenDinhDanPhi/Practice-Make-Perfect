//
//  GroupExample.swift
//  TestSwiftUI
//
//  Created by Dan Phi on 11/8/25.
//


import SwiftUI

struct GroupExample: View {
    var body: some View {
        VStack(spacing: 20) {
            Group {
                
                Text("First line")
                    .foregroundColor(.blue)
                Text("Second line")
                    .foregroundColor(.green)
            }
            .font(.headline) // modifier áp chung cho cả group
        }
        .padding()
    }
}

#Preview {
    GroupExample()
}
