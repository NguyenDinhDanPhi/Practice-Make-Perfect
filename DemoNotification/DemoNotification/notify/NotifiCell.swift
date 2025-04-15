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
    
    private let titleTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isSelectable = true
        textView.backgroundColor = .clear
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
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
    
    // Các biến thuộc tính cho titleRange và messRange
    private var titleRange: NSRange!
    private var messRange: NSRange!
    
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
        contentView.addSubview(titleTextView)
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
            
            titleTextView.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 12),
            titleTextView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 18),
            titleTextView.trailingAnchor.constraint(equalTo: thumbnailImageView.leadingAnchor, constant: -8),
            
            timeLabel.leadingAnchor.constraint(equalTo: titleTextView.leadingAnchor),
            timeLabel.topAnchor.constraint(equalTo: titleTextView.bottomAnchor, constant: 4),
            
            thumbnailImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            thumbnailImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            thumbnailImageView.widthAnchor.constraint(equalToConstant: 60),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 60),
        ])
        titleTextView.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    // MARK: - Configuration
    
    func configure(inboxNotice: InboxNotices) {
        let thumbnailURL = inboxNotice.message.image ?? ""
        
        let titleText = inboxNotice.message.title
        let bodyText = inboxNotice.message.body ?? ""
        
        // Tạo NSMutableAttributedString từ title và body
        let fullText = NSMutableAttributedString(string: titleText + " " + bodyText)
        
        // Lưu các phạm vi của title và body
        titleRange = NSRange(location: 0, length: titleText.count)
        messRange = NSRange(location: titleText.count, length: bodyText.count)
        
        // Thêm thuộc tính font cho từng phần của văn bản
        fullText.addAttribute(.font, value: UIFont.systemFont(ofSize: 14, weight: .medium), range: titleRange)
        fullText.addAttribute(.font, value: UIFont.systemFont(ofSize: 14, weight: .regular), range: messRange)
        
        // Thêm các thuộc tính nhận diện cho title và body
        fullText.addAttribute(.foregroundColor, value: UIColor.black, range: titleRange)
        fullText.addAttribute(.foregroundColor, value: UIColor.gray, range: messRange)
        
        // Thêm gesture chung cho cả title và body
        titleTextView.isUserInteractionEnabled = true
        titleTextView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap))) // Một gesture duy nhất
        
        // Set text cho UITextView
        titleTextView.attributedText = fullText
        
        // Cấu hình Avatar
        let fromList = inboxNotice.attribute.from
        let profileURL = fromList.first?.image
        let overlayImage = fromList.count > 1 ? fromList[1].image : ""
        avatarView.configure(mainImage: profileURL, overlayImage: overlayImage)
        
        // Set ảnh thumbnail
        thumbnailImageView.sd_setImage(with: convertUrlToImgae(urlString: thumbnailURL))
    }
    
    func convertUrlToImgae(urlString: String) -> URL? {
        let url = URL(string: urlString)
        return url
    }
    
    // Duy nhất một gesture
    @objc private func handleTap(sender: UITapGestureRecognizer) {
        let location = sender.location(in: titleTextView)
        
        let textStorage = NSTextStorage(attributedString: titleTextView.attributedText!)
        let layoutManager = NSLayoutManager()
        
        let containerSize = titleTextView.bounds.size
        layoutManager.addTextContainer(NSTextContainer(size: containerSize))
        textStorage.addLayoutManager(layoutManager)
        
        let index = layoutManager.glyphIndex(for: location, in: layoutManager.textContainers.first!)
        
        if NSLocationInRange(index, titleRange) {
            print("Title tapped!")
            // Handle title tap logic
        } else if NSLocationInRange(index, messRange) {
            print("Body tapped!")
            // Handle body tap logic
        }
    }
}
