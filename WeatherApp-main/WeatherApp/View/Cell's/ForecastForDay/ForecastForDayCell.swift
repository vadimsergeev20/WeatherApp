//
//  NowTemCell.swift
//  WeatherApp
//
//  Created by Alexandr Ananchenko on 08.06.2022.
//

import UIKit

struct ForecastForDayCellModel {
    var title: String
    var icon: String?
    var temp: Double?
}

class ForecastForDayCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!

    func setupcCell(data: ForecastForDayCellModel) {
        if let icon = data.icon {imageView.image = UIImage(named: icon)}
        if let temp = data.temp {tempLabel.text = "\(Int(temp))°"}
        
        let date = DateService.shared.convertDate(strDate: data.title)
        let calendar = Calendar.current
        guard let date = date else {return}
        let hour = calendar.component(.hour, from: date)
        if hour < 10 { titleLabel.text = "0\(hour)" }
        else { titleLabel.text = "\(hour)" }
    }


}
