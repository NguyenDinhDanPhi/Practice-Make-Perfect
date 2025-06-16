import UIKit

class PageCell: UICollectionViewCell {
    private let label = UILabel()
    private weak var hostedController: UIViewController?

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 24)
        contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        // Remove old child if present
        if let old = hostedController {
            old.willMove(toParent: nil)
            old.view.removeFromSuperview()
            old.removeFromParent()
            hostedController = nil
        }
    }

    /// Embed một UIViewController con vào cell
    func embed(_ viewController: UIViewController, in parentVC: UIViewController) {
        // Nếu cùng instance thì không cần embed lại
        guard hostedController !== viewController else { return }
        // Xóa bất kỳ child cũ nào
        prepareForReuse()

        parentVC.addChild(viewController)
        // Đặt frame full cell hoặc tuỳ chỉnh inset nếu muốn
        viewController.view.frame = contentView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.addSubview(viewController.view)
        viewController.didMove(toParent: parentVC)
        hostedController = viewController
    }

    /// Configure cell với tab; parentVC là ViewController chứa UICollectionView
    func configure(for tab: HomeTab, parentVC: UIViewController) {
        label.text = tab.title
        // Optional: nếu background tuỳ theo tab:
        // contentView.backgroundColor = ...
        let vc = tab.viewController
        embed(vc, in: parentVC)
    }
}
