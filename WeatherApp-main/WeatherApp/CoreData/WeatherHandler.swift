//
//  WeatherHandler.swift
//  WeatherApp
//
//  Created by Alexandr Ananchenko on 09.06.2022.
//

import UIKit
import CoreData

final class WeatherHandler {
    
    private let appDelegate: AppDelegate
    private let context: NSManagedObjectContext
    
    init() {
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
    }
    
    func saveObject(weather: WeatherResult) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<WeatherAppModel> = WeatherAppModel.fetchRequest()

        do {
           let result = try context.fetch(fetchRequest)
            if let data = result.first {
                data.weather = weather
                try context.save()
            } else {
                guard let entity = NSEntityDescription.entity(forEntityName: "WeatherAppModel", in: context) else { return }
                let resultObject = WeatherAppModel(entity: entity, insertInto: context)
                resultObject.weather = weather
                try context.save()
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    func fetchRequest() -> [WeatherAppModel] {
        var result = [WeatherAppModel]()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<WeatherAppModel> = WeatherAppModel.fetchRequest()

        do {
            print(result)
            result = try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }

        return result
    }
}
