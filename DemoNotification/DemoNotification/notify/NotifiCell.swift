import UIKit
import SDWebImage

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
        label.numberOfLines = 0
        label.isUserInteractionEnabled = true
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

    private lazy var thumbnailImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 10
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private var titleRange: NSRange!
    private var messRange: NSRange!
    private var urlRedict: String = ""
    private var fromUrlRedict: String = ""

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
        contentView.addSubview(titleLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(thumbnailImageView)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleLabelTap(_:)))
        titleLabel.addGestureRecognizer(tapGesture)

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

    func configure(inboxNotice: InboxNotices) {
        let thumbnailURL = inboxNotice.message.image ?? ""
        urlRedict = inboxNotice.redirectURL ?? ""
        let titleText = inboxNotice.message.title
        let bodyText = inboxNotice.message.body ?? ""

        fromUrlRedict = inboxNotice.attribute.from.first?.redirectURL ?? ""

        let fullString = titleText + " " + bodyText
        let attributedString = NSMutableAttributedString(string: fullString)

        titleRange = NSRange(location: 0, length: titleText.count)
        messRange = NSRange(location: titleText.count + 1, length: bodyText.count)

        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 14, weight: .medium), range: titleRange)
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 14, weight: .regular), range: messRange)
        attributedString.addAttribute(.foregroundColor, value: UIColor.black, range: titleRange)
        attributedString.addAttribute(.foregroundColor, value: UIColor.gray, range: messRange)

        titleLabel.attributedText = attributedString

        let fromList = inboxNotice.attribute.from
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
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true

        }
    }

    func convertUrlToImage(urlString: String) -> URL? {
        return URL(string: urlString)
    }

    @objc private func handleLabelTap(_ sender: UITapGestureRecognizer) {
        guard let label = sender.view as? UILabel,
              let attributedText = label.attributedText else { return }

        let textStorage = NSTextStorage(attributedString: attributedText)
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: label.bounds.size)
        textContainer.lineFragmentPadding = 0
        textContainer.maximumNumberOfLines = label.numberOfLines
        textContainer.lineBreakMode = label.lineBreakMode

        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        let location = sender.location(in: label)
        let index = layoutManager.characterIndex(for: location, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)

        if NSLocationInRange(index, titleRange) {
            print("🔗 Tapped on title")
            if let url = URL(string: fromUrlRedict) {
                UIApplication.shared.open(url)
            }
        } else if NSLocationInRange(index, messRange) {
            print("🔗 Tapped on body")
            if let url = URL(string: urlRedict) {
                UIApplication.shared.open(url)
            }
        }
    }
}
