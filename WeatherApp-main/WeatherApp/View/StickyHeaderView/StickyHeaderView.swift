//
//  StickyHeaderView.swift
//  WeatherApp
//
//  Created by Alexandr Ananchenko on 09.06.2022.
//

import UIKit

class StickyHeaderView: UICollectionReusableView {
    @IBOutlet weak var titleLabel: UILabel!
    
    override func layoutSubviews() {
        self.backgroundColor = .clear
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
        addBottomBorderWithColor(color: .lightGray, width: 1)
    }
    func set(title: String) {
        titleLabel.text = title
    }
}
