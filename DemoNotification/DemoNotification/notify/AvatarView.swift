import UIKit
import SDWebImage

class AvatarView: UIView {
    var redictUrlImage: String = ""
    struct LayoutMetrics {
        static let imageSize: CGFloat = 36
        static let marginImage: CGFloat = 18
    }

    private lazy var mainImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.isUserInteractionEnabled = true // Đảm bảo image view có thể nhận sự tương tác
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(avatarTapped))
        iv.addGestureRecognizer(tapGesture)
        return iv
    }()

    private let overlayImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.borderWidth = 2
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.isHidden = true
        return iv
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setupViews() {
        addSubview(mainImageView)
        addSubview(overlayImageView)

        NSLayoutConstraint.activate([
            mainImageView.topAnchor.constraint(equalTo: topAnchor),
            mainImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainImageView.bottomAnchor.constraint(equalTo: bottomAnchor),

            overlayImageView.widthAnchor.constraint(equalToConstant: 50),
            overlayImageView.heightAnchor.constraint(equalToConstant: 50),
            overlayImageView.centerXAnchor.constraint(equalTo: mainImageView.centerXAnchor, constant: LayoutMetrics.marginImage),
            overlayImageView.centerYAnchor.constraint(equalTo: mainImageView.centerYAnchor, constant: LayoutMetrics.marginImage)
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        mainImageView.layer.cornerRadius = bounds.width / 2
        overlayImageView.layer.cornerRadius = overlayImageView.frame.width / 2
    }

    func configure(mainImage: String?, overlayImage: String?, redictUrl: String) {
        redictUrlImage = redictUrl
        
        mainImageView.image = UIImage(named: "avatar") // Sử dụng ảnh tạm

        if let overlay = overlayImage, !overlay.isEmpty {
            overlayImageView.isHidden = false
            overlayImageView.sd_setImage(with: convertStringToURL(urlString: overlay))
        } else {
            overlayImageView.isHidden = true
        }
    }
    
    func convertStringToURL(urlString: String) -> URL? {
        return URL(string: urlString)
    }
    
    @objc func avatarTapped() {
        print("avatarTapped called")  // Kiểm tra xem hàm có được gọi không
        
        if !redictUrlImage.isEmpty {
            guard let url = URL(string: redictUrlImage) else { return  }
            print("Opening URL: \(redictUrlImage)") // Debug log
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            print("No redirect URL set")
        }
    }
}
