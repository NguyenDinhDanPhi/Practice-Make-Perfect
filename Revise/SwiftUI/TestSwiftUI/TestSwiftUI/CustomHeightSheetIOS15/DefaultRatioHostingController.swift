// PartialBottomSheetDefault.swift
import SwiftUI
import UIKit

final class DefaultRatioHostingController<Content: View>: UIHostingController<Content> {
    override init(rootView: Content) {
        super.init(rootView: rootView)
        view.backgroundColor = .clear
    }
    @MainActor required dynamic init?(coder aDecoder: NSCoder) { fatalError() }
}

public struct PartialBottomSheetDefault<SheetContent: View>: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    let defaultRatio: CGFloat
    let sheetContent: () -> SheetContent

    public class Coordinator: NSObject {
        public var delegate: PartialSheetTransitioningDelegate?
        public override init() { super.init() }
    }
    public func makeCoordinator() -> Coordinator { Coordinator() }

    public func makeUIViewController(context: Context) -> UIViewController {
        let base = UIViewController()
        base.view.backgroundColor = .clear
        return base
    }

    public func updateUIViewController(_ base: UIViewController, context: Context) {
        if isPresented, base.presentedViewController == nil {
            let host = DefaultRatioHostingController(rootView: sheetContent())
            host.modalPresentationStyle = .custom

            let delegate = PartialSheetTransitioningDelegate(defaultRatio: defaultRatio)
            context.coordinator.delegate = delegate
            host.transitioningDelegate = delegate

            base.present(host, animated: true)
        } else if !isPresented, base.presentedViewController != nil {
            base.dismiss(animated: true)
        }
    }

    // 🔧 Cần public init để dùng ngoài module (nếu struct public)
    public init(
        isPresented: Binding<Bool>,
        defaultRatio: CGFloat,
        @ViewBuilder sheetContent: @escaping () -> SheetContent
    ) {
        self._isPresented = isPresented
        self.defaultRatio = defaultRatio
        self.sheetContent = sheetContent
    }
}

public extension View {
    /// Bottom sheet custom: chỉ dùng defaultRatio (ví dụ 0.45)
    func partialBottomSheetDefault<Content: View>(
        isPresented: Binding<Bool>,
        defaultRatio: CGFloat,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        background(
            PartialBottomSheetDefault(
                isPresented: isPresented,
                defaultRatio: defaultRatio,
                sheetContent: content
            )
        )
    }
}
