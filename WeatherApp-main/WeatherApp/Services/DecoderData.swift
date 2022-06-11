//
//  DecoderData.swift
//  WeatherApp
//
//  Created by Alexandr Ananchenko on 10.06.2022.
//

import Foundation

class DecoderData {
    static let shared = DecoderData()
    
    func decodeData(data: Data) -> WeatherModel? {
        do {
            let result = try JSONDecoder().decode(WeatherModel.self, from: data)
            return result
        } catch {
            print("Decode error NetworkManager: \(error.localizedDescription)")
            return nil
        }
    }
}
