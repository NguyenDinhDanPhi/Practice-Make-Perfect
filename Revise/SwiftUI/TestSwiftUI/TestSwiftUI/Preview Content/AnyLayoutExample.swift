//
//  AnyLayoutExample.swift
//  TestSwiftUI
//
//  Created by Dan Phi on 11/8/25.
//


import SwiftUI

struct AnyLayoutExample: View {
    @State private var isHorizontal = true
    
    // Tạo layout động
    var currentLayout: AnyLayout {
        isHorizontal ? AnyLayout(HStackLayout(spacing: 20)) :
                       AnyLayout(VStackLayout(spacing: 20))
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Nút toggle
            Button(action: {
                withAnimation(.easeInOut) {
                    isHorizontal.toggle()
                }
            }) {
                Text("Đổi layout")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            
            // Áp dụng AnyLayout
            currentLayout {
                ForEach(1...4, id: \.self) { i in
                    Circle()
                        .fill(Color.orange)
                        .frame(width: 60, height: 60)
                        .overlay(Text("\(i)").foregroundColor(.white))
                }
            }
            .padding()
        }
        .animation(.spring(), value: isHorizontal)
    }
}

#Preview {
    AnyLayoutExample()
}
