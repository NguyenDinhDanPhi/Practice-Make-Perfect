//
//  ShareViewController.swift
//  DemoURLScheme
//
//  Created by dan phi on 25/3/25.
//

import UIKit

class ShareViewController: UIViewController {
    
    private let shareItems: [ShareItem] = [
        ShareItem(icon: UIImage(named: "copyLink"), title: "Copy"),
        ShareItem(icon: UIImage(named: "fb"), title: "Facebook"),
        ShareItem(icon: UIImage(named: "mess"), title: "Messenger"),
        ShareItem(icon: UIImage(named: "tele"), title: "Telegram"),
        ShareItem(icon: UIImage(named: "insta"), title: "Instagram")
    ]
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 50, height: 68)  // Chỉnh lại kích thước cell
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .clear
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ShareCollectionViewCell.self, forCellWithReuseIdentifier: ShareCollectionViewCell.identifier)
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            collectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor),     collectionView.heightAnchor.constraint(equalToConstant: 68)
        ])
    }
}

// MARK: - UICollectionView Delegate & DataSource
extension ShareViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shareItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShareCollectionViewCell.identifier, for: indexPath) as! ShareCollectionViewCell
        cell.configure(with: shareItems[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Tapped on \(shareItems[indexPath.row].title)")
    }
}
