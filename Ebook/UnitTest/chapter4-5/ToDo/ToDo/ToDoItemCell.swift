//
//  ToDoItemCell.swift
//  ToDo
//
//  Created by Dan Phi on 12/5/25.
//

import UIKit

class ToDoItemCell: UITableViewCell {
    
    var titleLabel: UILabel
    var dateLabel: UILabel
    let locationLabel: UILabel
    
    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        titleLabel = UILabel()
        dateLabel = UILabel()
        locationLabel = UILabel()
        super.init(style: style,
                   reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(locationLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
