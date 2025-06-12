import UIKit
import SkeletonView

class NotifiSkeletonCell: UITableViewCell {
    
    static let identifier = "NotifiSkeletonCell"
    
    private let avatarView: UIView = {
        let view = UIView()
        view.isSkeletonable = true
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 30
        view.clipsToBounds = true
        return view
    }()
    
    private let titleLabeliew: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 4
        view.isSkeletonable = true
        return view
    }()
    private let timeLabelView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 4
        view.isSkeletonable = true
        return view
    }()
    
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
        
        [avatarView, titleLabeliew, timeLabelView, thumbnailImageView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        NSLayoutConstraint.activate([
            avatarView.widthAnchor.constraint(equalToConstant: 60),
            avatarView.heightAnchor.constraint(equalToConstant: 60),
            avatarView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            avatarView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 22),
            
            titleLabeliew.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 12),
            titleLabeliew.topAnchor.constraint(equalTo: avatarView.topAnchor, constant: 5),
            titleLabeliew.heightAnchor.constraint(equalToConstant: 16),
            titleLabeliew.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 2),
            
            timeLabelView.leadingAnchor.constraint(equalTo: titleLabeliew.leadingAnchor),
            timeLabelView.topAnchor.constraint(equalTo: titleLabeliew.bottomAnchor, constant: 8),
            timeLabelView.heightAnchor.constraint(equalToConstant: 10),
            timeLabelView.widthAnchor.constraint(equalToConstant: 70),
            
            thumbnailImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            thumbnailImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            thumbnailImageView.widthAnchor.constraint(equalToConstant: 60),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
}
