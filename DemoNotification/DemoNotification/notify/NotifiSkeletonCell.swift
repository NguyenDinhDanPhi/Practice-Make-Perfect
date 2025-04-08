import UIKit
import SkeletonView

class NotifiSkeletonCell: UITableViewCell {

    static let identifier = "NotifiSkeletonCell"

    private let avatarView = UIView()
    private let line1 = UIView()  // Skeleton for title
    private let line2 = UIView()  // Skeleton for time

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        isSkeletonable = true
        contentView.isSkeletonable = true
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        // Avatar skeleton view
        avatarView.backgroundColor = .lightGray
        avatarView.layer.cornerRadius = 30
        avatarView.clipsToBounds = true
        avatarView.isSkeletonable = true

        // Line 1 (Title) skeleton view
        line1.backgroundColor = .lightGray
        line1.layer.cornerRadius = 4
        line1.clipsToBounds = true
        line1.isSkeletonable = true

        // Line 2 (Time) skeleton view
        line2.backgroundColor = .lightGray
        line2.layer.cornerRadius = 4
        line1.clipsToBounds = true
        line2.isSkeletonable = true

        // Add subviews
        [avatarView, line1, line2].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }

        // Layout constraints
        NSLayoutConstraint.activate([
            avatarView.widthAnchor.constraint(equalToConstant: 60),
            avatarView.heightAnchor.constraint(equalToConstant: 60),
            avatarView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            avatarView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 22),

            line1.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 12),
            line1.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            line1.topAnchor.constraint(equalTo: avatarView.topAnchor),
            line1.heightAnchor.constraint(equalToConstant: 20),

            line2.leadingAnchor.constraint(equalTo: line1.leadingAnchor),
            line2.trailingAnchor.constraint(equalTo: line1.trailingAnchor),
            line2.topAnchor.constraint(equalTo: line1.bottomAnchor, constant: 8),
            line2.heightAnchor.constraint(equalToConstant: 16),
        ])
    }

    // Function to start skeleton animation for all views
    func startSkeleton() {
        [avatarView, line1, line2].forEach {
            $0.showAnimatedGradientSkeleton()  // Ensure skeleton for avatar, title, and time
        }
    }

    // Function to stop skeleton animation
    func stopSkeleton() {
        [avatarView, line1, line2].forEach {
            $0.hideSkeleton()
        }
    }

    // Prepare cell for reuse to reset skeleton animation
    override func prepareForReuse() {
        super.prepareForReuse()
        stopSkeleton()
    }
}
