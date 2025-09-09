import UIKit

// MARK: - ActionCardView
/// Thẻ trắng có icon + tiêu đề + mũi tên
final class ActionCardView: UIControl {

    // Container trắng (shadow nhẹ, không viền)
    private let container: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor.white.withAlphaComponent(0.92)
        v.layer.cornerRadius = 12
        v.layer.borderWidth = 0
        v.layer.borderColor = nil
        v.layer.shadowColor = UIColor.black.cgColor
        v.layer.shadowOpacity = 0.05
        v.layer.shadowRadius = 6
        v.layer.shadowOffset = CGSize(width: 0, height: 2)
        return v
    }()

    private let iconView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.tintColor = UIColor.black.withAlphaComponent(0.8)
        iv.setContentCompressionResistancePriority(.required, for: .horizontal)
        return iv
    }()

    private let titleLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = .systemFont(ofSize: 15, weight: .semibold)
        lb.textColor = UIColor(white: 0, alpha: 0.87)
        lb.numberOfLines = 2
        return lb
    }()

    // MARK: - Init
    init(icon: UIImage?, title: String) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false

        iconView.image = icon
        titleLabel.text = title
        setUpView()
    }
    
    private func setUpView() {
        addSubview(container)
        container.addSubview(iconView)
        container.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: topAnchor),
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor),

            iconView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
            iconView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 22),
            iconView.heightAnchor.constraint(equalToConstant: 22),


            titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 10),
        ])
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
