//
//  ViewThatFitsExample.swift
//  TestSwiftUI
//
//  Created by Dan Phi on 11/8/25.
//


import SwiftUI

struct ViewThatFitsExample: View {
    var body: some View {
        VStack {
            Text("Resize cửa sổ hoặc xoay màn hình để thấy thay đổi")
                .font(.caption)
                .foregroundColor(.gray)

            ViewThatFits(in: .horizontal) { // thử theo chiều ngang trước
                // 1️⃣ Layout ưu tiên: HStack (nếu vừa)
                HStack {
                    Color.red.frame(width: 100, height: 100)
                    Color.green.frame(width: 100, height: 100)
                    Color.blue.frame(width: 100, height: 100)
                }

                // 2️⃣ Layout fallback: VStack (nếu HStack không vừa)
                VStack {
                    Color.red.frame(width: 100, height: 100)
                    Color.green.frame(width: 100, height: 100)
                    Color.blue.frame(width: 100, height: 100)
                }
            }
            .padding()
            .border(.gray)
        }
        .padding()
    }
}

#Preview {
    ViewThatFitsExample()
}
