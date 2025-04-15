//
//  NotifiCell.swift
//  DemoNotification
//
//  Created by dan phi on 3/4/25.
//

import UIKit

class NotifiCell: UITableViewCell {
    
    static let identifier = "NotifiCell"
    
    private let avatarView: AvatarView = {
        let view = AvatarView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    private lazy var redDotView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.layer.cornerRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let thumbnailImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 10
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor(red: 1.0, green: 0.99, blue: 0.94, alpha: 1.0) // màu kem
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    private func setupViews() {
        contentView.addSubview(avatarView)
        contentView.addSubview(redDotView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(thumbnailImageView)
        
        self.contentView.layer.masksToBounds = false
        self.layer.masksToBounds = false
        NSLayoutConstraint.activate([
            
            redDotView.widthAnchor.constraint(equalToConstant: 6),
            redDotView.heightAnchor.constraint(equalToConstant: 6),
            redDotView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            redDotView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            avatarView.leadingAnchor.constraint(equalTo: redDotView.trailingAnchor, constant: 8),
            avatarView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            avatarView.widthAnchor.constraint(equalToConstant: 60),
            avatarView.heightAnchor.constraint(equalToConstant: 60),
            
            titleLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 12),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 18),
            titleLabel.trailingAnchor.constraint(equalTo: thumbnailImageView.leadingAnchor, constant: -8),
            
            timeLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            timeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            
            thumbnailImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            thumbnailImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            thumbnailImageView.widthAnchor.constraint(equalToConstant: 60),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    // MARK: - Configuration
    
    func configure(inboxNotice: InboxNotices) {
        //let time = timeAgoString(from: Date(timeIntervalSince1970: TimeInterval(item.createdAt.timestamp)))
        let thumbnailURL = inboxNotice.message.image ?? ""
        
        let titleText = inboxNotice.message.title
        let bodyText = inboxNotice.message.body ?? ""
        // Tạo NSMutableAttributedString từ title và body
        let fullText = NSMutableAttributedString(string: titleText + " " + bodyText)
        let titleRange = NSRange(location: 0, length: titleText.count)
        let messRange = NSRange(location: titleText.count, length: bodyText.count)
        fullText.addAttribute(.font, value: UIFont.systemFont(ofSize: 14, weight: .medium), range: titleRange)
        fullText.addAttribute(.font, value:  UIFont.systemFont(ofSize: 14, weight: .regular), range: messRange)
        let fromList = inboxNotice.attribute.from
        let profileURL = fromList.first?.image
        let overlayImage = fromList.count > 1 ? fromList[1].image : ""
        
        avatarView.configure(mainImage: profileURL, overlayImage: overlayImage)
        titleLabel.attributedText = fullText
        
        thumbnailImageView.sd_setImage(with: convertUrlToImgae(urlString: thumbnailURL))
        
//        switch typeRender {
//        case .userAction:
//            print("haha user action")
//        case .common:
//            print("haha common")
//        }
//        print("image profile \(profileImage)")
//        print("image overlay \(overlayImage)")
//        avatarView.configure(mainImage: profileImage, overlayImage: overlayImage)
//        titleLabel.text = title
//        timeLabel.text = time
//        thumbnailImageView.sd_setImage(with: convertUrlToImgae(urlString: "https://images.fptplay53.net/media/OTT/VOD/2025/03/18/chi-em-tranh-dau-fpt-play-1742291882787_Landscape.jpg") )
//        redDotView.isHidden = hiddenRed
    }
    
    func convertUrlToImgae(urlString: String) -> URL?{
        let url =  URL(string: urlString)
        return url
    }

}
