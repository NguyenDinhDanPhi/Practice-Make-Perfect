//
//  BecomeStreamerViewController.swift
//  demoVNID
//
//  Created by Dan Phi on 9/9/25.
//


import UIKit

final class StartStreamerViewController: UIViewController {

    private let studioLink = URL(string: "https://studio.fangtv.vn/stream")!

    // MARK: - UI
    private let backgroundImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "streamerMascot"))
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let dimView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        v.isUserInteractionEnabled = false
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let panelView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = 12
        return v
    }()

    private let titleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Bạn đã là streamer FangTV"
        lb.font = .systemFont(ofSize: 20, weight: .semibold)
        lb.textColor = UIColor(white: 0, alpha: 0.87)
        lb.numberOfLines = 0
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()

    private let subtitleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Vài bước đơn giản để bắt đầu live stream"
        lb.font = .systemFont(ofSize: 14, weight: .regular)
        lb.textColor = UIColor(white: 0, alpha: 0.6)
        lb.numberOfLines = 0
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()

    private lazy var computerCard = ActionCardView(
        icon: UIImage(systemName: "laptopcomputer"),
        title: "Sử dụng máy tính"
    )

    private lazy var openStudioCard = ActionCardView(
        icon: UIImage(systemName: "link"),
        title: "Mở liên kết đến studio của FangTV"
    )

    private let openSwitchLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Mở liên kết"
        lb.font = .systemFont(ofSize: 14, weight: .regular)
        lb.textColor = UIColor(white: 0, alpha: 0.87)
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    private let openSwitch: UISwitch = {
        let sw = UISwitch()
        sw.translatesAutoresizingMaskIntoConstraints = false
        return sw
    }()

    private let copyButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setTitle("Sao chép liên kết", for: .normal)
        bt.setTitleColor(.white, for: .normal)
        bt.backgroundColor = .black
        bt.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        bt.layer.cornerRadius = 10
        bt.translatesAutoresizingMaskIntoConstraints = false
        return bt
    }()

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        makeNavBarTransparentAndUnderlap()
        setupHierarchy()
        setupConstraints()
        bindActions()
    }

    // MARK: - Nav bar underlap
    private func makeNavBarTransparentAndUnderlap() {
        edgesForExtendedLayout = [.top, .bottom]
        extendedLayoutIncludesOpaqueBars = true

        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = .black
        navigationItem.title = "Quay lại"
    }

    // MARK: - Layout
    private func setupHierarchy() {
        view.addSubview(backgroundImageView)
        view.addSubview(dimView)

        // Panel + các view con
        view.addSubview(panelView)
        panelView.addSubview(titleLabel)
        panelView.addSubview(subtitleLabel)
        panelView.addSubview(computerCard)
        panelView.addSubview(openStudioCard)

        let switchRow = UIView()
        switchRow.translatesAutoresizingMaskIntoConstraints = false
        panelView.addSubview(switchRow)
        switchRow.addSubview(openSwitchLabel)
        switchRow.addSubview(openSwitch)

        panelView.addSubview(copyButton)

        // Constraints trong switchRow
        NSLayoutConstraint.activate([
            openSwitch.centerYAnchor.constraint(equalTo: openSwitchLabel.centerYAnchor),
            openSwitch.trailingAnchor.constraint(equalTo: switchRow.trailingAnchor),
            openSwitchLabel.leadingAnchor.constraint(equalTo: switchRow.leadingAnchor),
            openSwitchLabel.topAnchor.constraint(equalTo: switchRow.topAnchor, constant: 12),
            openSwitchLabel.bottomAnchor.constraint(equalTo: switchRow.bottomAnchor, constant: -12)
        ])
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Nền full, chạy dưới cả nav bar
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            dimView.topAnchor.constraint(equalTo: view.topAnchor),
            dimView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dimView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            // Panel trắng: leading/trailing = 12, bottom = 22
            panelView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            panelView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            panelView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -22),
        ])

        // Bên trong panel
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: panelView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: panelView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: panelView.trailingAnchor, constant: -16),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            computerCard.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 16),
            computerCard.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            computerCard.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            computerCard.heightAnchor.constraint(greaterThanOrEqualToConstant: 56),

            openStudioCard.topAnchor.constraint(equalTo: computerCard.bottomAnchor, constant: 12),
            openStudioCard.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            openStudioCard.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            openStudioCard.heightAnchor.constraint(greaterThanOrEqualToConstant: 56),

            // switchRow ngay dưới 2 card
            openSwitchLabel.superview!.topAnchor.constraint(equalTo: openStudioCard.bottomAnchor, constant: 16),
            openSwitchLabel.superview!.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            openSwitchLabel.superview!.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            copyButton.topAnchor.constraint(equalTo: openSwitchLabel.superview!.bottomAnchor, constant: 16),
            copyButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            copyButton.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            copyButton.heightAnchor.constraint(equalToConstant: 48),

            // Đóng đáy panel
            copyButton.bottomAnchor.constraint(equalTo: panelView.bottomAnchor, constant: -16)
        ])
    }

    // MARK: - Actions
    private func bindActions() {
        computerCard.addTarget(self, action: #selector(didTapComputer), for: .touchUpInside)
        openStudioCard.addTarget(self, action: #selector(didTapOpenStudio), for: .touchUpInside)
        copyButton.addTarget(self, action: #selector(didTapCopy), for: .touchUpInside)
        openSwitch.addTarget(self, action: #selector(didChangeOpenSwitch), for: .valueChanged)
    }

    @objc private func didTapComputer() {
        let alert = UIAlertController(title: "Hướng dẫn",
                                      message: "Mở tài liệu hướng dẫn dùng máy tính để stream.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    @objc private func didTapOpenStudio() {
        UIApplication.shared.open(studioLink, options: [:], completionHandler: nil)
    }

    @objc private func didTapCopy() {
        UIPasteboard.general.string = studioLink.absoluteString
        let alert = UIAlertController(title: nil, message: "Đã sao chép liên kết", preferredStyle: .alert)
        present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
            self?.dismiss(animated: true)
        }
    }

    @objc private func didChangeOpenSwitch(_ sw: UISwitch) {
        if sw.isOn {
            UIApplication.shared.open(studioLink, options: [:], completionHandler: nil)
        }
    }
}
