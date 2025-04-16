import UIKit
import SDWebImage



class NotifiCell: UITableViewCell {
    var markAsRead: (() -> Void)?
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
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.isUserInteractionEnabled = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var thumbnailImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 10
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapThumbnail))
        iv.addGestureRecognizer(tapGesture)
        return iv
    }()
    
    private var personRange: NSRange!
    private var seconRange: NSRange!
    private var moreRange: NSRange!
    private var bodyRange: NSRange!
    
    private var renderType: RenderType?
    
    private var redirectUrl: String = ""
    private var fromRedirectUrl: String = ""
    private var redirectContent: String = ""
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor(red: 1.0, green: 0.99, blue: 0.94, alpha: 1.0)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(avatarView)
        contentView.addSubview(redDotView)
        
        contentView.addSubview(timeLabel)
        contentView.addSubview(thumbnailImageView)
        
        
        contentView.addSubview(titleLabel)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleLabelTap(_:)))
        titleLabel.addGestureRecognizer(tapGesture)
        
        
        
        NSLayoutConstraint.activate([
            redDotView.widthAnchor.constraint(equalToConstant: 6),
            redDotView.heightAnchor.constraint(equalToConstant: 6),
            redDotView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            redDotView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 8),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            timeLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            timeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            avatarView.leadingAnchor.constraint(equalTo: redDotView.trailingAnchor, constant: 8),
            avatarView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            avatarView.widthAnchor.constraint(equalToConstant: 60),
            avatarView.heightAnchor.constraint(equalToConstant: 60),
            
            thumbnailImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            thumbnailImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            thumbnailImageView.widthAnchor.constraint(equalToConstant: 60),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    func configure(inboxNotice: InboxNotices) {
        
        let thumbnailURL = inboxNotice.message.image ?? ""
        let fromList = inboxNotice.attribute.from
        renderType = inboxNotice.typeRender
        switch renderType {
        case .userAction:
            let firstPersonString = fromList.first?.name ?? ""
            let secondPersonString = fromList.count > 1 ? fromList[1].name ?? "" : ""
            let moreString = inboxNotice.attribute.extra?.more ?? ""
            let bodyString = inboxNotice.message.body ?? ""
            
            
            
            titleLabel.attributedText = buildAttributedText(
                    person: firstPersonString,
                    second: secondPersonString,
                    more: moreString,
                    body: bodyString
                )
        
        case .common:
            let string = inboxNotice.message.title ?? ""
            titleLabel.text = string
        case .none:
            break
        }
       
        redirectUrl = inboxNotice.redirectURL ?? ""
        fromRedirectUrl = inboxNotice.attribute.from.first?.redirectURL ?? ""
        redirectContent = inboxNotice.redirectContent ?? ""
        
        let profileURL = fromList.first?.image
        let overlayImage = fromList.count > 1 ? fromList[1].image : ""
        let avataRedirect = fromList.first?.redirectURL ?? ""
        avatarView.configure(mainImage: profileURL, overlayImage: overlayImage, redictUrl: avataRedirect)
        
        if !thumbnailURL.isEmpty {
            thumbnailImageView.isHidden = false
            titleLabel.trailingAnchor.constraint(equalTo: thumbnailImageView.leadingAnchor, constant: -8).isActive = true
            thumbnailImageView.sd_setImage(with: convertUrlToImage(urlString: thumbnailURL))
        } else {
            thumbnailImageView.isHidden = true
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18).isActive = true
            
        }
    }
    
    func convertUrlToImage(urlString: String) -> URL? {
        return URL(string: urlString)
    }
    
    private func buildAttributedText(person: String, second: String, more: String, body: String) -> NSAttributedString {
        let personSecondText = second.isEmpty ? person : "\(person), \(second)"
        let moreText = more.isEmpty ? "" : " và \(more)"
        let fullText = "\(personSecondText)\(moreText) \(body)"
        let attributedText = NSMutableAttributedString(string: fullText)

        let personStart = 0
        let personLength = person.count
        personRange = NSRange(location: personStart, length: personLength)

        var seconStart = 0
        if !second.isEmpty {
            seconStart = person.count + 2 // ", "
            seconRange = NSRange(location: seconStart, length: second.count)
        } else {
            seconRange = NSRange(location: 0, length: 0)
        }

        var moreStart = 0
        if !more.isEmpty {
            moreStart = personSecondText.count + 4 // " và " = 4 ký tự
            moreRange = NSRange(location: moreStart, length: more.count)
        } else {
            moreRange = NSRange(location: 0, length: 0)
        }

        let spaceBeforeBody = 1
        let bodyStart = fullText.count - body.count
        bodyRange = NSRange(location: bodyStart, length: body.count)

        attributedText.addAttributes([
            .font: UIFont.systemFont(ofSize: 14, weight: .medium),
            .foregroundColor: UIColor.black
        ], range: personRange)

        if seconRange.length > 0 {
            attributedText.addAttributes([
                .font: UIFont.systemFont(ofSize: 14, weight: .medium),
                .foregroundColor: UIColor.black
            ], range: seconRange)
        }

        if moreRange.length > 0 {
            attributedText.addAttributes([
                .font: UIFont.systemFont(ofSize: 14, weight: .medium),
                .foregroundColor: UIColor.black
            ], range: moreRange)
        }

        attributedText.addAttributes([
            .font: UIFont.systemFont(ofSize: 14, weight: .regular),
            .foregroundColor: UIColor.black
        ], range: bodyRange)

        return attributedText
    }




    @objc private func handleLabelTap(_ sender: UITapGestureRecognizer) {
        switch renderType {
        case .userAction:
            guard let label = sender.view as? UILabel,
                  let attributedText = label.attributedText else { return }

            let index = characterIndexTapped(in: label, sender: sender, attributedText: attributedText)
            print("👉 Tap index:", index)

            switch index {
            case _ where NSLocationInRange(index, personRange):
                print("🟢 personRange tapped")
                if let url = URL(string: fromRedirectUrl) {
                    openUrl(url: url)
                }
            case _ where NSLocationInRange(index, seconRange):
                print("🟡 seconRange tapped")

            case _ where NSLocationInRange(index, moreRange):
                print("🔵 moreRange tapped")

            case _ where NSLocationInRange(index, bodyRange):
                if let url = URL(string: redirectContent) {
                    openUrl(url: url)
                }

            default:
                print("⚪️ Outside target ranges")
            }

        case .common:
            print("hehe")
        case nil:
            break
        }
    }
    
    private func characterIndexTapped(in label: UILabel, sender: UITapGestureRecognizer, attributedText: NSAttributedString) -> Int {
        label.layoutIfNeeded()

        let textStorage = NSTextStorage(attributedString: attributedText)
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: label.bounds.size)

        textContainer.lineFragmentPadding = 0
        textContainer.maximumNumberOfLines = label.numberOfLines
        textContainer.lineBreakMode = label.lineBreakMode

        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        let touchPoint = sender.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)

        let xOffset = (label.bounds.width - textBoundingBox.width) / 2.0 - textBoundingBox.origin.x
        let yOffset = (label.bounds.height - textBoundingBox.height) / 2.0 - textBoundingBox.origin.y
        let location = CGPoint(x: touchPoint.x - xOffset, y: touchPoint.y - yOffset)

        return layoutManager.characterIndex(for: location, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
    }


    
    
    @objc func tapThumbnail() {
        markAsRead?()
        if let url = URL(string: redirectContent) {
            UIApplication.shared.open(url)
        }
        
    }
    
    func openUrl(url: URL) {
        UIApplication.shared.open(url)
    }
}
