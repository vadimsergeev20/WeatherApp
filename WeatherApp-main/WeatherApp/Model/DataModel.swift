//
//  DataModel.swift
//  WeatherApp
//
//  Created by Alexandr Ananchenko on 08.06.2022.
//

import Foundation

class DataModel: Hashable {

    var weatherNowData: WeatherCellProtocol?
    init(weatherNowData: WeatherCellProtocol) {
        self.weatherNowData = weatherNowData
    }
    
    var forecastForDayData: ForecastForDayCellModel?
    init(forecastForDayData: ForecastForDayCellModel) {
        self.forecastForDayData = forecastForDayData
    }
    
    var weeklyForecastData: WeeklyForecastCellData?
    init(weeklyForecastData: WeeklyForecastCellData) {
        self.weeklyForecastData = weeklyForecastData
    }
    
    //MARK: - Hashable
    var uuid = UUID()
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(uuid)
    }
    
    static func == (lhs: DataModel, rhs: DataModel) -> Bool {
      lhs.uuid == rhs.uuid
    }
}
