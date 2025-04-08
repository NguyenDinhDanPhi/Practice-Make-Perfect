import UIKit
import SkeletonView

class NotifiSkeletonCell: UITableViewCell {

    static let identifier = "NotifiSkeletonCell"

    private let avatarView = UIView()
    private let line1 = UIView()  // Skeleton for title
    private let line2 = UIView()  // Skeleton for time
    
    private let thumbnailImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 10
        iv.clipsToBounds = true
        iv.isSkeletonable = true
        return iv
    }()
    
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
        line1.isSkeletonable = true // Đảm bảo rằng line1 có thể hiện skeleton

        // Line 2 (Time) skeleton view
        line2.backgroundColor = .lightGray
        line2.layer.cornerRadius = 4
        line2.isSkeletonable = true // Đảm bảo rằng line2 có thể hiện skeleton

        // Add subviews
        [avatarView, line1, line2, thumbnailImageView].forEach {
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
            line1.topAnchor.constraint(equalTo: avatarView.topAnchor),
            line1.heightAnchor.constraint(equalToConstant: 20),
            line1.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 2),

            line2.leadingAnchor.constraint(equalTo: line1.leadingAnchor),
            line2.topAnchor.constraint(equalTo: line1.bottomAnchor, constant: 8),
            line2.heightAnchor.constraint(equalToConstant: 10),
            line2.widthAnchor.constraint(equalToConstant: 40),
            
            thumbnailImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            thumbnailImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            thumbnailImageView.widthAnchor.constraint(equalToConstant: 60),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

}
