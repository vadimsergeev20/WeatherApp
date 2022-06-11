//
//  SectionBGView.swift
//  WeatherApp
//
//  Created by Alexandr Ananchenko on 09.06.2022.
//

import UIKit

class SectionBGView: UICollectionReusableView {
    private var insetView: UIView = {
          let view = UIView()
          view.translatesAutoresizingMaskIntoConstraints = false
          view.backgroundColor = .secondarySystemFill
          view.layer.cornerRadius = 15
          view.clipsToBounds = true
          return view
      }()

      override init(frame: CGRect) {
          super.init(frame: frame)
          backgroundColor = .clear
          addSubview(insetView)
          
          NSLayoutConstraint.activate([
              insetView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
              trailingAnchor.constraint(equalTo: insetView.trailingAnchor, constant: 0),
              insetView.topAnchor.constraint(equalTo: topAnchor),
              insetView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
          ])
      }

      required init?(coder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }
}
