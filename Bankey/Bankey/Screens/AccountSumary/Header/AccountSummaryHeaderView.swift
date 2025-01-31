//
//  AccountSummaryHeaderView.swift
//  Bankey
//
//  Created by dan phi on 27/01/2025.
//

import UIKit
class AccountSummaryHeaderView: UIView {
    
    @IBOutlet var containverView: UIView!
    var shakeyBellView = ShakeyBellView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 144)
    }
    
    private func commonInit() {
        let bundle = Bundle(for: AccountSummaryHeaderView.self)
        bundle.loadNibNamed("AccountSummaryHeaderView", owner: self, options: nil)
        addSubview(containverView)
        containverView.backgroundColor = .systemTeal
        
        containverView.translatesAutoresizingMaskIntoConstraints = false
        containverView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        containverView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        containverView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        containverView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        setupShakeyBell()
    }
    
    private func setupShakeyBell() {
            shakeyBellView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(shakeyBellView)
            
            NSLayoutConstraint.activate([
                shakeyBellView.trailingAnchor.constraint(equalTo: trailingAnchor),
                shakeyBellView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        }
    
}
