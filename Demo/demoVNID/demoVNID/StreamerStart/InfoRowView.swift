import UIKit

// MARK: - Reusable row
final class InfoRowView: UIView {
    enum TrailingAction {
        case copy
        case toggleSecure
        case refresh
    }

    // UI
    private let titleLabel = UILabel()
    private let container = UIView()
    private let leftIcon = UIImageView()
    private let valueLabel = UILabel()
    private let buttonsStack = UIStackView()

    // State
    private var plainText: String
    private(set) var isSecure: Bool
    private var actions: [TrailingAction]

    // Callbacks
    var onCopy: ((String) -> Void)?
    var onRefresh: (() -> String)?   // return new text khi refresh
    var onToggleSecure: ((Bool) -> Void)?

    // MARK: Init
    init(title: String,
         icon: UIImage?,
         text: String,
         isSecure: Bool = false,
         actions: [TrailingAction]) {
        self.plainText = text
        self.isSecure = isSecure
        self.actions = actions
        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = false
        setupUI(title: title, icon: icon)
        configureButtons()
        updateValueLabel()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: Public
    func setText(_ text: String) {
        plainText = text
        updateValueLabel()
    }

    func setSecure(_ secure: Bool) {
        isSecure = secure
        updateValueLabel()
    }

    // MARK: Private
    private func setupUI(title: String, icon: UIImage?) {
        // title
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .systemFont(ofSize: 12, weight: .regular)
        titleLabel.textColor = .secondaryLabel
        titleLabel.text = title

        // container
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .secondarySystemBackground
        container.layer.cornerRadius = 12

        // left icon
        leftIcon.translatesAutoresizingMaskIntoConstraints = false
        leftIcon.contentMode = .scaleAspectFit
        leftIcon.image = icon
        leftIcon.setContentHuggingPriority(.required, for: .horizontal)
        leftIcon.setContentCompressionResistancePriority(.required, for: .horizontal)

        // text
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.font = .systemFont(ofSize: 14, weight: .regular)
        valueLabel.textColor = .label
        valueLabel.numberOfLines = 1
        valueLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        // buttons
        buttonsStack.translatesAutoresizingMaskIntoConstraints = false
        buttonsStack.axis = .horizontal
        buttonsStack.spacing = 8
        buttonsStack.alignment = .center
        buttonsStack.setContentHuggingPriority(.required, for: .horizontal)
        buttonsStack.setContentCompressionResistancePriority(.required, for: .horizontal)

        addSubview(titleLabel)
        addSubview(container)
        container.addSubview(leftIcon)
        container.addSubview(valueLabel)
        container.addSubview(buttonsStack)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),

            container.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.heightAnchor.constraint(equalToConstant: 48),
            container.bottomAnchor.constraint(equalTo: bottomAnchor),

            leftIcon.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
            leftIcon.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            leftIcon.widthAnchor.constraint(equalToConstant: 18),
            leftIcon.heightAnchor.constraint(equalToConstant: 18),

            buttonsStack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8),
            buttonsStack.centerYAnchor.constraint(equalTo: container.centerYAnchor),

            valueLabel.leadingAnchor.constraint(equalTo: leftIcon.trailingAnchor, constant: 10),
            valueLabel.trailingAnchor.constraint(lessThanOrEqualTo: buttonsStack.leadingAnchor, constant: -8),
            valueLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
    }

    private func configureButtons() {
        buttonsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for action in actions {
            let btn = UIButton(type: .system)
            btn.translatesAutoresizingMaskIntoConstraints = false
            btn.tintColor = .tertiaryLabel
            btn.widthAnchor.constraint(equalToConstant: 28).isActive = true
            btn.heightAnchor.constraint(equalToConstant: 28).isActive = true

            switch action {
            case .copy:
                btn.setImage(UIImage(systemName: "doc.on.doc"), for: .normal)
                btn.addTarget(self, action: #selector(didTapCopy), for: .touchUpInside)
            case .toggleSecure:
                let name = isSecure ? "eye" : "eye.slash"
                btn.setImage(UIImage(systemName: name), for: .normal)
                btn.addTarget(self, action: #selector(didTapToggleSecure(_:)), for: .touchUpInside)
            case .refresh:
                btn.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
                btn.addTarget(self, action: #selector(didTapRefresh), for: .touchUpInside)
            }
            buttonsStack.addArrangedSubview(btn)
        }
    }

    private func updateValueLabel() {
        if isSecure {
            let count = max(8, plainText.count)
            valueLabel.text = String(repeating: "•", count: count)
        } else {
            valueLabel.text = plainText
        }
        // update icon eye if có
        if let eye = buttonsStack.arrangedSubviews.compactMap({ $0 as? UIButton })
            .first(where: { $0.actions(forTarget: self, forControlEvent: .touchUpInside)?.contains("didTapToggleSecure:") == true }) {
            let name = isSecure ? "eye" : "eye.slash"
            eye.setImage(UIImage(systemName: name), for: .normal)
        }
    }

    // MARK: Actions
    @objc private func didTapCopy() {
        onCopy?(plainText)
    }

    @objc private func didTapRefresh() {
        if let new = onRefresh?() {
            plainText = new
            updateValueLabel()
        }
    }

    @objc private func didTapToggleSecure(_ sender: UIButton) {
        isSecure.toggle()
        onToggleSecure?(isSecure)
        updateValueLabel()
    }
}

//// MARK: - Screen
//final class LiveInfoViewController: UIViewController {
//
//    // Mock data
//    private var streamURL = "fangtv.vn/example123"
//    private var streamKey = "sk_live_1a2b3c4d5e6f7g8h"
//
//    // Header
//    private let titleLabel: UILabel = {
//        let l = UILabel()
//        l.translatesAutoresizingMaskIntoConstraints = false
//        l.text = "Thông tin phát LIVE"
//        l.font = .systemFont(ofSize: 16, weight: .semibold)
//        l.textColor = .label
//        return l
//    }()
//
//    private let illustrationView: UIImageView = {
//        let iv = UIImageView(image: UIImage(named: "streamerMascot"))
//        iv.translatesAutoresizingMaskIntoConstraints = false
//        iv.contentMode = .scaleAspectFit
//        return iv
//    }()
//
//    // Rows
//    private lazy var urlRow = InfoRowView(
//        title: "Stream URL",
//        icon: UIImage(systemName: "link"),
//        text: streamURL,
//        actions: [.copy]
//    )
//
//    private lazy var keyRow = InfoRowView(
//        title: "Stream key",
//        icon: UIImage(systemName: "key.fill"),
//        text: streamKey,
//        isSecure: true,
//        actions: [.toggleSecure, .refresh, .copy]
//    )
//
//    private let contentStack: UIStackView = {
//        let st = UIStackView()
//        st.translatesAutoresizingMaskIntoConstraints = false
//        st.axis = .vertical
//        st.spacing = 12
//        return st
//    }()
//
//    // MARK: Life cycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = UIColor.systemGroupedBackground
//        configureNavBar()
//        buildHierarchy()
//        setupCallbacks()
//    }
//
//    private func configureNavBar() {
//        view.backgroundColor = .systemGroupedBackground
//        navigationItem.title = nil
//        navigationItem.leftBarButtonItem = UIBarButtonItem(
//            image: UIImage(systemName: "chevron.left"),
//            style: .plain,
//            target: self,
//            action: #selector(didTapBack)
//        )
//        navigationController?.navigationBar.tintColor = .label
//    }
//
//    private func buildHierarchy() {
//        view.addSubview(titleLabel)
//        view.addSubview(illustrationView)
//        view.addSubview(contentStack)
//
//        contentStack.addArrangedSubview(urlRow)
//        contentStack.addArrangedSubview(keyRow)
//
//        NSLayoutConstraint.activate([
//            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
//            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//
//            illustrationView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
//            illustrationView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
//            illustrationView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
//            illustrationView.heightAnchor.constraint(equalToConstant: 160),
//
//            contentStack.topAnchor.constraint(equalTo: illustrationView.bottomAnchor, constant: 16),
//            contentStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            contentStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
//            contentStack.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12)
//        ])
//    }
//
//    private func setupCallbacks() {
//        urlRow.onCopy = { [weak self] text in
//            UIPasteboard.general.string = text
//            self?.toast("Đã sao chép URL")
//        }
//
//        keyRow.onCopy = { [weak self] text in
//            UIPasteboard.general.string = text
//            self?.toast("Đã sao chép Stream key")
//        }
//
//        keyRow.onRefresh = { [weak self] in
//            // Tạo key mới demo
//            let letters = "abcdefghijklmnopqrstuvwxyz0123456789"
//            let tail = String((0..<16).map { _ in letters.randomElement()! })
//            let newKey = "sk_live_\(tail)"
//            self?.streamKey = newKey
//            return newKey
//        }
//
//        keyRow.onToggleSecure = { _ in /* có thể log analytics nếu cần */ }
//    }
//
//    @objc private func didTapBack() {
//        if let nav = navigationController, nav.viewControllers.first != self {
//            nav.popViewController(animated: true)
//        } else {
//            dismiss(animated: true)
//        }
//    }
//
//    // Simple toast
//    private func toast(_ message: String) {
//        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
//        present(alert, animated: true)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
//            self?.dismiss(animated: true)
//        }
//    }
//}
