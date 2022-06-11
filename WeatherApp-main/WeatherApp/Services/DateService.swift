//
//  DateService.swift
//  WeatherApp
//
//  Created by Alexandr Ananchenko on 09.06.2022.
//

import Foundation

class DateService {
    static let shared = DateService()
    
     func convertDate(strDate: String) -> Date? {
        let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: strDate)

        return date
    }
     func isSameDay(date1: Date?, date2: Date?) -> Bool {
         guard let date1 = date1, let date2 = date2 else {
             return false
         }

        let calendar = Calendar.current
        let status = calendar.isDate(date1, inSameDayAs: date2)

        return status
    }
    func stringDay(date: Date?) -> String {
        guard let date = date else { return "" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EE"
        let dayOfTheWeekString = dateFormatter.string(from: date)
        return dayOfTheWeekString
    }
}
