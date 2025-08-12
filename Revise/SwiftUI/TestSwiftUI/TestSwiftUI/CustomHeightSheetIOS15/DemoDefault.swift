//
//  DemoDefault.swift
//  TestSwiftUI
//
//  Created by Dan Phi on 12/8/25.
//
import SwiftUI

struct DemoDefault: View {
    @State private var show = false
    var body: some View {
        Button("Open (default 45%)") { show = true }
            .partialBottomSheetDefault(isPresented: $show, defaultRatio: 0.45) {
                SheetBody { show = false }
            }
    }
}

// SheetBody.swift
import SwiftUI

public struct SheetBody: View {
    public var onClose: () -> Void
    public init(onClose: @escaping () -> Void) { self.onClose = onClose }

    public var body: some View {
        VStack(spacing: 12) {
            // (grabber đã add từ PresentationController)
            Text("Custom Bottom Sheet").font(.headline)

            Text("Chiều cao điều khiển bởi UIPresentationController custom.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Button("Close") { onClose() }
                .buttonStyle(.bordered)
                .padding(.top, 8)
        }
        // padding CHO NỘI DUNG
        .padding(.horizontal, 20)
        .padding(.top, 50)
        .padding(.bottom, 20)

        // 👇 Quan trọng: giãn full khung sheet và gắn background ở đây
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color(.systemBackground))
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    DemoDefault()
}
