//
//  ContentPopupModifier.swift
//  TestSwiftUI
//
//  Created by Dan Phi on 11/8/25.
//


import SwiftUI

struct ContentPopupModifier: ViewModifier {
    @Binding var isPresented: Bool
    let text: String

    // Tuỳ biến nhanh
    var alignment: Alignment = .top
    var autoDismiss: Double? = nil               // giây; nil = không tự tắt
    var bgColor: Color = Color.black.opacity(0.85)
    var fgColor: Color = .white
    var cornerRadius: CGFloat = 12
    var padding: CGFloat = 12
    var transition: AnyTransition = .scale.combined(with: .opacity)

    func body(content: Content) -> some View {
        content
            .overlay(alignment: alignment) {
                if isPresented {
                    Text(text)
                        .multilineTextAlignment(.center)
                        .padding(padding)
                        .background(bgColor)
                        .foregroundStyle(fgColor)
                        .cornerRadius(cornerRadius)
                        .transition(transition)
                        .onAppear {
                            if let delay = autoDismiss {
                                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                                    withAnimation { isPresented = false }
                                }
                            }
                        }
                }
            }
    }
}

extension View {
    /// Dùng nhanh: hiển thị popup text nổi trên content.
    func contentPopup(
        isPresented: Binding<Bool>,
        text: String,
        alignment: Alignment = .top,
        autoDismiss: Double? = nil,
        bgColor: Color = Color.black.opacity(0.85),
        fgColor: Color = .white,
        cornerRadius: CGFloat = 12,
        padding: CGFloat = 12,
        transition: AnyTransition = .scale.combined(with: .opacity)
    ) -> some View {
        modifier(ContentPopupModifier(
            isPresented: isPresented,
            text: text,
            alignment: alignment,
            autoDismiss: autoDismiss,
            bgColor: bgColor,
            fgColor: fgColor,
            cornerRadius: cornerRadius,
            padding: padding,
            transition: transition
        ))
    }
}
