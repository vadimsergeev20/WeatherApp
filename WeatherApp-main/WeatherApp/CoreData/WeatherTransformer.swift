//
//  WeatherTransformer.swift
//  WeatherApp
//
//  Created by Alexandr Ananchenko on 09.06.2022.
//

import Foundation

//MARK: - WeatherTransformer
class WeatherTransformer: NSSecureUnarchiveFromDataTransformer {
    override class var allowedTopLevelClasses: [AnyClass] {
        return super.allowedTopLevelClasses + [WeatherResult.self]
    }
    
    static func register() {
        let className = String(describing: WeatherResult.self)
        let name = NSValueTransformerName(className)
        let transformer = WeatherTransformer()

        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
}
//MARK: - WeatherResult
public class WeatherResult: NSObject, NSSecureCoding, Codable {
    public static var supportsSecureCoding = true

    var list: [ListResult]
    var city: CityResult

    enum Key: String {
        case list = "list"
        case city = "city"
    }
    init(list: [ListResult], city: CityResult) {
        self.list = list
        self.city = city
        
        super.init()
    }

    public func encode(with coder: NSCoder) {
        coder.encode(list, forKey: Key.list.rawValue)
        coder.encode(city, forKey: Key.city.rawValue)
    }
    public required convenience init?(coder: NSCoder) {
        let mList = coder.decodeObject(forKey: Key.list.rawValue) as! [ListResult]
        let mCity = coder.decodeObject(forKey: Key.city.rawValue) as! CityResult


        self.init(list: mList, city: mCity)
    }
}
//MARK: - CityResult
public class ListResult: NSObject, NSSecureCoding, Codable {
    public static var supportsSecureCoding = true

    let main: MainClassResult
    let weather: [WeatherResultCD]
    let dtTxt: String
    enum Key: String {
        case main = "main"
        case weather = "weather"
        case dtTxt = "dtTxt"
    }
    init(main: MainClassResult, weather: [WeatherResultCD], dtTxt: String) {
        self.main = main
        self.weather = weather
        self.dtTxt = dtTxt
        
        super.init()
    }

    public func encode(with coder: NSCoder) {
        coder.encode(main, forKey: Key.main.rawValue)
        coder.encode(weather, forKey: Key.weather.rawValue)
        coder.encode(dtTxt, forKey: Key.dtTxt.rawValue)
    }

    public required convenience init?(coder: NSCoder) {
        let mMain =  coder.decodeObject(forKey: Key.main.rawValue) as! MainClassResult
        let mWeather = coder.decodeObject(forKey: Key.weather.rawValue) as! [WeatherResultCD]
        let mDtTxt = coder.decodeObject(forKey: Key.dtTxt.rawValue) as! String


        self.init(main: mMain, weather: mWeather, dtTxt: mDtTxt)
    }
    
}
//MARK: - CityResult
public class CityResult: NSObject, NSSecureCoding, Codable {
    var id: Int
    
    public static var supportsSecureCoding = true

//    var cityId: Int
    var name: String
    enum Key: String {
        case id = "id"
        case name = "name"
    }
    init(cityId: Int, name: String) {
        self.id = cityId
        self.name = name
        
        super.init()
    }

    public func encode(with coder: NSCoder) {
        coder.encode(id, forKey: Key.id.rawValue)
        coder.encode(name, forKey: Key.name.rawValue)
    }

    public required convenience init?(coder: NSCoder) {
        let mCityId = coder.decodeInt64(forKey: Key.id.rawValue)
        let mCity = coder.decodeObject(forKey: Key.name.rawValue) as! String


        self.init(cityId: Int(mCityId), name: mCity)
    }
    
}
//MARK: - MainClassResult
public class  MainClassResult: NSObject, NSSecureCoding, Codable {
    public static var supportsSecureCoding = true

    var temp: Double
    var tempMin: Double
    var tempMax: Double
    enum Key: String {
        case temp = "temp"
        case tempMin = "tempMin"
        case tempMax = "tempMax"
    }
    init(temp: Double, tempMin: Double, tempMax: Double) {
        self.temp = temp
        self.tempMin = tempMin
        self.tempMax = tempMax
        
        super.init()
    }

    public func encode(with coder: NSCoder) {
        coder.encode(temp, forKey: Key.temp.rawValue)
        coder.encode(tempMin, forKey: Key.tempMin.rawValue)
        coder.encode(tempMax, forKey: Key.tempMax.rawValue)
    }

    public required convenience init?(coder: NSCoder) {
        let mTemp = coder.decodeDouble(forKey: Key.temp.rawValue)
        let mMinTemp = coder.decodeDouble(forKey: Key.tempMin.rawValue)
        let mMaxTemp = coder.decodeDouble(forKey: Key.tempMax.rawValue)
        

        self.init(temp: mTemp, tempMin: mMinTemp, tempMax: mMaxTemp)
    }
}
//MARK: - WeatherResultCD
class WeatherResultCD: NSObject, NSSecureCoding, Codable {
    public static var supportsSecureCoding = true

    var id: Int
    var weatherDescription: String
    var icon: String
    enum Key: String {
        case id = "id"
        case weatherDescription = "weatherDescription"
        case icon = "icon"
    }
    init(id: Int, weatherDescription: String, icon: String) {
        self.id = id
        self.weatherDescription = weatherDescription
        self.icon = icon
        
        super.init()
    }

    public func encode(with coder: NSCoder) {
        coder.encode(id, forKey: Key.id.rawValue)
        coder.encode(weatherDescription, forKey: Key.weatherDescription.rawValue)
        coder.encode(icon, forKey: Key.icon.rawValue)
    }

    public required convenience init?(coder: NSCoder) {
        let mId = coder.decodeInt64(forKey: Key.id.rawValue)
        let mWeatherDescription = coder.decodeObject(forKey: Key.weatherDescription.rawValue) as! String
        let mIcon = coder.decodeObject(forKey: Key.icon.rawValue) as! String
  
        self.init(id: Int(mId), weatherDescription: mWeatherDescription, icon: mIcon)
    }
}
