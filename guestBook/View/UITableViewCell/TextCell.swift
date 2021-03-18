//
//  TextCell.swift
//  guestBook
//
//  Created by Tomohiro Ikeda on 2021/03/17.
//

import UIKit

class TextCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setText(text: String) {
        self.textLabel?.text = text
    }
}
