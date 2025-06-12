import UIKit

final class InfoBoxView: UIView {
    
    // MARK: - Subviews

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = titleColor
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var subContentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = contentLabel.textColor // trùng màu content
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .lightGray // riêng biệt
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, contentLabel, subContentLabel, timeLabel])
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - Data
    
    private let titleText: String
    private let contentText: String
    private let subContentText: String?
    private let timeText: String?
    private let titleColor: UIColor
    
    // MARK: - Init
    
    init(title: String, content: String, subContent: String? = nil, time: String? = nil, titleColor: UIColor = .label) {
        self.titleText = title
        self.contentText = content
        self.subContentText = subContent
        self.timeText = time
        self.titleColor = titleColor
        super.init(frame: .zero)
        setupView()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup
    
    private func setupView() {
        backgroundColor = .white
        layer.cornerRadius = 4
       

        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }

    private func configure() {
        titleLabel.text = titleText
        titleLabel.textColor = titleColor
        contentLabel.text = contentText

        if let sub = subContentText, !sub.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            subContentLabel.text = sub
            subContentLabel.isHidden = false
        } else {
            subContentLabel.isHidden = true
        }

        if let time = timeText, !time.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            timeLabel.text = time
            timeLabel.isHidden = false
        } else {
            timeLabel.isHidden = true
        }
    }
}
