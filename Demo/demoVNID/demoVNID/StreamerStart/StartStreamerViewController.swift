//
//  BecomeStreamerViewController.swift
//  demoVNID
//
//  Created by Dan Phi on 9/9/25.
//


import UIKit

final class StartStreamerViewController: UIViewController {

    private let studioLink = URL(string: "https://studio.fangtv.vn/stream")!
    private var streamURL = "fangtv.vn/example123"
    private var streamKey = "sk_live_1a2b3c4d5e6f7g8h"
    // MARK: - UI
    private let backgroundImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "streamerMascot"))
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
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
        v.backgroundColor = .lightGray
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = 12
        return v
    }()

        private lazy var urlRow = InfoRowView(
            title: "Stream URL",
            icon: UIImage(systemName: "link"),
            text: streamURL,
            actions: [.copy]
        )
        private lazy var keyRow = InfoRowView(
            title: "Stream key",
            icon: UIImage(systemName: "key.fill"),
            text: streamKey,
            isSecure: true,
            actions: [.toggleSecure, .refresh, .copy]
        )

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        makeNavBarTransparentAndUnderlap()
        setupConstraints()
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

    private func setupConstraints() {

        view.addSubview(backgroundImageView)
        view.addSubview(panelView)
        panelView.addSubview(urlRow)
        panelView.addSubview(keyRow)
        urlRow.translatesAutoresizingMaskIntoConstraints = false
        keyRow.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor,constant: 2),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.37),
            
            panelView.topAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -20),
            panelView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            panelView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            panelView.heightAnchor.constraint(equalToConstant: 200),
            
            urlRow.topAnchor.constraint(equalTo: panelView.topAnchor, constant: 12),
            urlRow.leadingAnchor.constraint(equalTo: panelView.leadingAnchor, constant: 10),
            urlRow.trailingAnchor.constraint(equalTo: panelView.trailingAnchor, constant: -10),
            urlRow.heightAnchor.constraint(greaterThanOrEqualToConstant: 52),

            keyRow.topAnchor.constraint(equalTo: urlRow.bottomAnchor, constant: 12),
            keyRow.leadingAnchor.constraint(equalTo: panelView.leadingAnchor, constant: 12),
            keyRow.trailingAnchor.constraint(equalTo: panelView.trailingAnchor, constant: -12),
            keyRow.heightAnchor.constraint(greaterThanOrEqualToConstant: 52)
        ])
    }

    // MARK: - Actions
}
