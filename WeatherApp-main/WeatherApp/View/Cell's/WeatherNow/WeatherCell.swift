//
//  MainCell.swift
//  WeatherApp
//
//  Created by Alexandr Ananchenko on 08.06.2022.
//

import UIKit

struct WeatherCellProtocol {
    var city: String
    var temp: Double?
    var description: String?
    var maxTemp: Double?
    var minTemp: Double?
    
    init(city: String, temp: Double?, description: String?, maxTemp: Double?, minTemp: Double?) {
        self.city = city
        self.temp = temp
        self.description = description
        self.maxTemp = maxTemp
        self.minTemp = minTemp
    }
}

class WeatherCell: UICollectionViewCell {
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!

    func setupCell(data: WeatherCellProtocol) {
        cityLabel.text = data.city
        descriptionLabel.text = data.description
        
        if let temp = data.temp {tempLabel.text = "\(Int(temp))°"}
        if let maxTemp = data.maxTemp, let minTemp = data.minTemp {
            maxTempLabel.text = "Макс.: \(Int(maxTemp))°, мин.: \(Int(minTemp))°"
        }
    }
}
