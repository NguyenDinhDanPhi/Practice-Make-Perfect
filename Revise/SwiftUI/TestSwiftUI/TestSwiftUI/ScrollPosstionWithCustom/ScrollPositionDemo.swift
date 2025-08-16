//
//  ScrollPositionDemo.swift
//  TestSwiftUI
//
//  Created by Dan Phi on 11/8/25.
//


import SwiftUI

struct ScrollPositionDemo: View {
    @State private var topVisibleID: Int? = 0
    @State private var target = 75
    @State private var showPopup = false

    var body: some View {
        ScrollViewReader { proxy in
            VStack(spacing: 12) {
                // Nút cuộn nhanh
                Text("row \(topVisibleID ?? 0)")
                    .padding(.bottom)
                HStack {
                    Button("Top")    { proxy.scrollTo(0, anchor: .top) }
                    Button("Middle") { proxy.scrollTo(target, anchor: .center) }
                    Button("Bottom") { proxy.scrollTo(149, anchor: .bottom) }
                }
                .buttonStyle(.bordered)

                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 8) {
                        
                        ForEach(0..<150, id: \.self) { i in
                            Text("Row \(i)")
                                .id(i)
                                .padding(.horizontal)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(i == target ? .yellow.opacity(0.3) : .clear)
                        }
                    }
                }
                .scrollTargetLayout()
                .scrollPosition(id: $topVisibleID)
                .onChange(of: topVisibleID) { _, new in
                    
                    topVisibleID = new
                    if let top = new {
                        print("Top-most id:", top)
                        
                        // Khi hàng 100 xuất hiện ở mép trên
                        if top == 100 {
                            withAnimation {
                                showPopup = true
                            }
                            
                            // Tự ẩn sau 2 giây
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation {
                                    showPopup = false
                                }
                            }
                        }
                    }
                }
                .onAppear {
                    topVisibleID =  target
                }
            }
            .padding()
            .contentPopup(isPresented: $showPopup, text: "📢 Bạn đã cuộn tới hàng 100!")
        }
    }
}

#Preview {
    ScrollPositionDemo()
}
