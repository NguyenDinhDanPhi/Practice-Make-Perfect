//
//  GroupBoxExample.swift
//  TestSwiftUI
//
//  Created by Dan Phi on 11/8/25.
//


import SwiftUI

struct GroupBoxExample: View {
    var body: some View {
        VStack(spacing: 20) {
            GroupBox(label: Label("User Info", systemImage: "person.circle")) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Name: John Doe")
                    Text("Email: john@example.com")
                }
                .padding(.top, 4)
                
            }
           

            GroupBox(label: Text("Settings")) {
                Toggle("Enable notifications", isOn: .constant(true))
                Toggle("Dark mode", isOn: .constant(true))
            }
        }
        .padding()
        
    }
}

#Preview {
    GroupBoxExample()
}
