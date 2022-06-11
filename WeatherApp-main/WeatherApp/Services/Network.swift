//
//  Network.swift
//  WeatherApp
//
//  Created by Alexandr Ananchenko on 08.06.2022.
//

import Foundation

class Network {
    static let shared = Network()
    private init() {}
    private let apiKey = "a1c267562cc3718d8fc8976825e6a3d1"
    private let baseUrl = "https://api.openweathermap.org/data/2.5/forecast"
    func fetchData(long: Double, lat: Double, completion: @escaping (WeatherModel?, Error?)  -> Void) {
        let urlString = baseUrl + "?lat=\(lat)&lon=\(long)" + "&appid=a1c267562cc3718d8fc8976825e6a3d1" + "&units=metric"
        
        guard let url = URL(string: urlString) else { return }
        
        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, response, error in
  
            if let data = data, error == nil, let result = DecoderData.shared.decodeData(data: data) {
                completion(result, nil)
            } else {
                completion(nil, error)
            }
        }
        task.resume()
    }

  
}
