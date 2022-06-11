//
//  AllWeekTempCell.swift
//  WeatherApp
//
//  Created by Alexandr Ananchenko on 08.06.2022.
//

import UIKit

struct WeeklyForecastCellData {
    let day: String
    let image: String?
    let minTemp: Double?
    let maxTemp: Double?
}

class WeeklyForecastCell: UICollectionViewCell {
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!

    func setupCell(data: WeeklyForecastCellData) {
        let date = DateService.shared.convertDate(strDate: data.day)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EE"
        let dayOfTheWeekString = DateService.shared.stringDay(date: date)
        if DateService.shared.isSameDay(date1: Date.now, date2: date) { dayLabel.text = "Сегодня" }
        else { dayLabel.text = dayOfTheWeekString.capitalized }
        if let icon = data.image { self.imageView.image = UIImage(named: icon)}
        if let minTemp = data.minTemp {self.minTempLabel.text = "\(Int(minTemp))°"}
        if let maxTmep = data.maxTemp {self.maxTempLabel.text = "\(Int(maxTmep))°"}
      
    }
}
