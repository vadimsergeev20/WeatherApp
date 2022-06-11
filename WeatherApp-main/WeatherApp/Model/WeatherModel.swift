//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Alexandr Ananchenko on 08.06.2022.
//

import Foundation

// MARK: - WeatherModel
struct WeatherModel: Codable {
    let list: [List]
    let city: City
    
    init(list: [List], city: City) {
        self.list = list
        self.city = city
    }
    init(list: [ListResult], city: CityResult) {
        self.list = list.map { List(main: $0.main, weather: $0.weather, dtTxt: $0.dtTxt)}
        self.city = City(id: city.id, name: city.name)
    }
}

// MARK: - City
struct City: Codable {
    let id: Int
    let name: String
}

// MARK: - List
struct List: Codable {
    let main: MainClass
    let weather: [Weather]
    let dtTxt: String

    init(main: MainClass, weather: [Weather], dtTxt: String) {
        self.main = main
        self.weather = weather
        self.dtTxt = dtTxt
    }
    init(main: MainClassResult, weather: [WeatherResultCD], dtTxt: String) {
        self.main = MainClass(temp: main.temp, tempMin: main.tempMin, tempMax: main.tempMax)
        self.weather = weather.map { Weather(id: $0.id, weatherDescription: $0.weatherDescription, icon: $0.icon) }
        self.dtTxt = dtTxt
    }
            
    enum CodingKeys: String, CodingKey {
        case main, weather
        case dtTxt = "dt_txt"
    }
}


// MARK: - MainClass
struct MainClass: Codable {
    let temp, tempMin, tempMax: Double
    
    enum CodingKeys: String, CodingKey {
        case temp
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int
    let weatherDescription, icon: String

    init(id: Int, weatherDescription: String, icon: String) {
        self.id  = id
        self.weatherDescription = weatherDescription
        self.icon = icon
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case weatherDescription = "description"
        case icon
    }
}
