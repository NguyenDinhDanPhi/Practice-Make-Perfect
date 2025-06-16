//
//  HomeTab.swift
//  CloneTikTok
//
//  Created by Dan Phi on 16/6/25.
//


import UIKit

// MARK: - Tab Enum
import UIKit

// MARK: - Tab Enum
enum HomeTab: Int, CaseIterable {
    case friends, following, forYou

    var title: String {
        switch self {
        case .friends: return "Bạn bè"
        case .following: return "Đã follow"
        case .forYou: return "Đề xuất"
        }
    }
    
    // Trả về instance ViewController tương ứng
    var viewController: UIViewController {
        switch self {
        case .friends:
            return FriendsViewController()
        case .following:
            return FollowingViewController()
        case .forYou:
            return ForYouViewController()
        }
    }
}


// MARK: - Tab Header View
import UIKit

class TabHeaderView: UIStackView {

    var buttons: [UIButton] = []
    var selectedIndex: Int = 0 {
        didSet {
            updateSelection(animated: true)
        }
    }

    var onTabSelected: ((Int) -> Void)?

    private let underlineView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        axis = .horizontal
        distribution = .fillEqually
        alignment = .fill
        spacing = 0

        // Tạo các tab
        HomeTab.allCases.enumerated().forEach { (index, tab) in
            let button = UIButton(type: .system)
            button.setTitle(tab.title, for: .normal)
            button.backgroundColor = .clear
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
            button.tag = index
            button.addTarget(self, action: #selector(tabTapped(_:)), for: .touchUpInside)

            buttons.append(button)
            addArrangedSubview(button)
        }

        // Thêm underline
        underlineView.backgroundColor = .white
        underlineView.translatesAutoresizingMaskIntoConstraints = true
        underlineView.frame = .zero
        addSubview(underlineView)

        // Mặc định chọn tab
        selectedIndex = 2 // Ví dụ chọn "Đề xuất"
        layoutIfNeeded()
        updateSelection(animated: false)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateSelection(animated: false)
    }

    private func updateSelection(animated: Bool = true) {
        for (i, button) in buttons.enumerated() {
            let isSelected = (i == selectedIndex)
            button.titleLabel?.font = .systemFont(ofSize: 16, weight: isSelected ? .bold : .regular)
        }

        guard selectedIndex < buttons.count else { return }
        let selectedButton = buttons[selectedIndex]
        let fullW = selectedButton.frame.width
        let underlineHeight: CGFloat = 2
        let underlineW = fullW / 3
        let underlineX = selectedButton.frame.origin.x + (fullW - underlineW) / 2
        let underlineY = bounds.height - underlineHeight

        let frame = CGRect(x: underlineX, y: underlineY, width: underlineW, height: underlineHeight)
        if animated {
            UIView.animate(withDuration: 0.25) {
                self.underlineView.frame = frame
            }
        } else {
            underlineView.frame = frame
        }
    }

    @objc private func tabTapped(_ sender: UIButton) {
        selectedIndex = sender.tag
        updateSelection(animated: true)
        onTabSelected?(selectedIndex)
    }

    // Call this from scrollViewDidScroll to move underline when swiping
    func updateUnderlinePosition(scrollOffsetX: CGFloat, scrollViewWidth: CGFloat) {
        guard buttons.count > 0 else { return }

        let fullButtonWidth = bounds.width / CGFloat(buttons.count)
        let underlineWidth = fullButtonWidth / 3

        // Tính index dạng float và phần lẻ
        let tabIndexFractional = scrollOffsetX / scrollViewWidth
        let baseIndex = Int(tabIndexFractional)
        let progress = tabIndexFractional - CGFloat(baseIndex)

        // Lấy x origin của button hiện tại và kế tiếp (an toàn)
        let currentX = buttons[safe: baseIndex]?.frame.origin.x ?? 0
        let nextX    = buttons[safe: baseIndex + 1]?.frame.origin.x ?? currentX

        // Nội suy vị trí giữa hai button
        let interpolatedX = currentX + (nextX - currentX) * progress

        // Căn giữa underline trong button
        let underlineX = interpolatedX + (fullButtonWidth - underlineWidth) / 2
        let underlineY = bounds.height - 2

        underlineView.frame = CGRect(x: underlineX, y: underlineY,
                                     width: underlineWidth,
                                     height: 2)
    }


}

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
