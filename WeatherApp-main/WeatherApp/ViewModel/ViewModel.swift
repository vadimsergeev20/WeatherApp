//
//  Presenter.swift
//  WeatherApp
//
//  Created by Alexandr Ananchenko on 08.06.2022.
//

import Foundation
import Network
import CoreLocation

class ViewModel: NSObject, CLLocationManagerDelegate {
    private let dateService = DateService.shared
    private let weatherHandler = WeatherHandler()
    private let monitor = NWPathMonitor()
    private  let queue = DispatchQueue(label: "Monitor")
    private let locationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    private var internetConnection: Bool?
 
    
    let weatherNowBox: Box<[DataModel]> = Box(.init())
    let forecastForDayBox: Box<[DataModel]> = Box(.init())
    let weeklyForecastBox: Box<[DataModel]> = Box(.init())
    let errorBox: Box<String> = Box(.init())

    override init() {
        super.init()
        internetStatus()
        setupLocation()
    }
    
    private func internetStatus() {
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                self.internetConnection = true
            } else {
                DispatchQueue.main.async { self.fetchLocalData() }
                self.internetConnection = false
            }
        }
        monitor.start(queue: queue)
    }
    
    private func fetchLocalData() {
        let data = weatherHandler.fetchRequest()
        guard let weather = data.last?.weather else { return }
        let model = WeatherModel(list: weather.list, city: weather.city)
        self.configureWeatherNow(data: model)
        self.configureForecastForDay(data: model)
        self.configureWeeklyForecast(data: model)
    }
    
    private func setupLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty, currentLocation == nil, let internetConnection = self.internetConnection, internetConnection {
            currentLocation = locations.first
            locationManager.stopUpdatingHeading()
            fetchRemoteData()
        }
    }
    
    private func fetchRemoteData() {
        guard let currentLocation = currentLocation else { return }

        Network.shared.fetchData(long: currentLocation.coordinate.longitude, lat: currentLocation.coordinate.latitude) { data, error in
            guard let data = data else {
                self.errorBox.value = error!.localizedDescription
                return
            }
            DispatchQueue.main.async { self.saveInCoreData(data: data) }
            
            self.configureWeatherNow(data: data)
            self.configureForecastForDay(data: data)
            self.configureWeeklyForecast(data: data)
        }
    }
    
    private func saveInCoreData(data: WeatherModel) {
        let lists = data.list.map { MainClassResult(temp: $0.main.temp, tempMin: $0.main.tempMin, tempMax: $0.main.tempMax)}
        guard let weather = data.list.first?.weather else { return }
        let weathers = weather.map { WeatherResultCD(id: $0.id, weatherDescription: $0.weatherDescription, icon: $0.icon)}
        
        
        var resultLists: [ListResult] = []
        for (index, element) in lists.enumerated() {
            let result = ListResult(main: element, weather: weathers, dtTxt: data.list[index].dtTxt)
            resultLists.append(result)
        }
        let city = CityResult(cityId: data.city.id, name: data.city.name)
        let result = WeatherResult(list: resultLists, city: city)
        self.weatherHandler.saveObject(weather: result)
    }
    
    private func configureWeatherNow(data: WeatherModel) {
        let result = WeatherCellProtocol(city: data.city.name, temp: data.list.first?.main.temp, description: data.list.first?.weather.first?.weatherDescription, maxTemp: data.list.first?.main.tempMax, minTemp: data.list.first?.main.tempMin)
        let dataModel = DataModel(weatherNowData: result)
        weatherNowBox.value = [dataModel]
    }
    private func configureForecastForDay(data: WeatherModel) {
        let list = self.filterListForOneDay(data: data.list)
        let temperature = list.map { list in
            ForecastForDayCellModel(title: list.dtTxt, icon: list.weather.first?.icon, temp: list.main.temp)
        }
       
        let dataModel = temperature.map { DataModel(forecastForDayData: $0)}
        forecastForDayBox.value = dataModel
    }
    private func configureWeeklyForecast(data: WeatherModel) {
        var lists: [List] = []
        data.list.forEach { list in
            guard !lists.isEmpty else { lists.append(list); return }
            
            if let last = lists.last {
               guard let dateOne = dateService.convertDate(strDate: last.dtTxt),
                     let dateTwo = dateService.convertDate(strDate: list.dtTxt) else { return }
                if !dateService.isSameDay(date1: dateOne, date2: dateTwo) { lists.append(list) }
            }
        }
        
        let temperatures = lists.map { list in
            WeeklyForecastCellData(day: list.dtTxt, image: list.weather.first?.icon, minTemp: list.main.tempMin, maxTemp: list.main.tempMax)
        }
        let dataModel = temperatures.map { DataModel(weeklyForecastData: $0) }
        weeklyForecastBox.value = dataModel
    }
    
    private func filterListForOneDay(data: [List]) -> [List] {
       return data.filter { list in
           if let date = dateService.convertDate(strDate: list.dtTxt), dateService.isSameDay(date1: date, date2: Date.now) {
                return true
            } else { return false }
        }
    }
}

