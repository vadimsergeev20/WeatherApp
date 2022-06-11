//
//  ViewViewController.swift
//  WeatherApp
//
//  Created by Alexandr Ananchenko on 08.06.2022.
//

import UIKit

class ViewViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Sections, DataModel>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Sections, DataModel>
    private lazy var dataSource = makeDataSource()
    private let viewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollection()
        activityIndicator.startAnimating()

        
        viewModel.weatherNowBox.listener = { [weak self] data in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.applySnapshot(append: data, to: .weatherNow)
            }
        }
        viewModel.forecastForDayBox.listener = { [weak self] data in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.applySnapshot(append: data, to: .forecastForDay)
            }
        }
        viewModel.weeklyForecastBox.listener = { [weak self] data in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.applySnapshot(append: data, to: .weeklyForecast)
            }
        }
        viewModel.errorBox.listener = { [weak self] error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.showAlert(title: "Error", message: error)
            }
        }
    }

    func setupCollection() {
        //WeatherNowCell
        let nibNameWeatherNowCell = String(describing: WeatherCell.self)
        let nibWeatherNowCell = UINib(nibName: nibNameWeatherNowCell, bundle: nil)
        collectionView.register(nibWeatherNowCell, forCellWithReuseIdentifier: Identifiers.weatherNowCellIdentifier.rawValue)
        //ForecastForDayCell
        let nibNameForecastForDayCell = String(describing: ForecastForDayCell.self)
        let nibForecastForDayCell = UINib(nibName: nibNameForecastForDayCell, bundle: nil)
        collectionView.register(nibForecastForDayCell, forCellWithReuseIdentifier: Identifiers.forecastForDayCellIdentifier.rawValue)
        //WeeklyForecastCell
        let nibNameWeeklyForecastCell = String(describing: WeeklyForecastCell.self)
        let nibWeeklyForecastCell = UINib(nibName: nibNameWeeklyForecastCell, bundle: nil)
        collectionView.register(nibWeeklyForecastCell, forCellWithReuseIdentifier: Identifiers.weeklyForecastCellIdentifier.rawValue)

        let headerNibName = String(describing: StickyHeaderView.self)
        let headerNib = UINib(nibName: headerNibName, bundle: nil)
        collectionView.register(headerNib, forSupplementaryViewOfKind: Identifiers.headerElementKind.rawValue, withReuseIdentifier: Identifiers.headerElementKindIdentifier.rawValue)
        
        collectionView.collectionViewLayout = genereteLayout()
    }
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
}
//MARK: - Identifiers
extension ViewViewController {
    enum Identifiers: String {
        case weatherNowCellIdentifier = "WeatherNowCell"
        case forecastForDayCellIdentifier = "ForecastForDayCell"
        case weeklyForecastCellIdentifier = "WeeklyForecastCell"
        
        case headerElementKind = "Header"
        case headerElementKindIdentifier = "HeaderIdentifier"
        case sectionBGView = "SectionBG"
    }
}
//MARK: - DataSource
extension ViewViewController {
   private func makeDataSource() -> DataSource {
       let dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
           let section = Sections.allCases[indexPath.section]
           switch section {
           case .weatherNow:
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.weatherNowCellIdentifier.rawValue, for: indexPath) as! WeatherCell
               if let data = itemIdentifier.weatherNowData { cell.setupCell(data: data) }
               return cell
           case .forecastForDay:
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.forecastForDayCellIdentifier.rawValue, for: indexPath) as! ForecastForDayCell
               if let data = itemIdentifier.forecastForDayData { cell.setupcCell(data: data) }
               return cell
           case .weeklyForecast:
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.weeklyForecastCellIdentifier.rawValue, for: indexPath) as! WeeklyForecastCell
               if let data = itemIdentifier.weeklyForecastData { cell.setupCell(data: data) }
               return cell
           }
       }
       
       
       dataSource.supplementaryViewProvider = {  (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
           if kind == Identifiers.headerElementKind.rawValue {
               let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Identifiers.headerElementKindIdentifier.rawValue, for: indexPath) as! StickyHeaderView
               if indexPath.section == 2 { header.set(title: "Прогноз на 6 дней") }
               
               return header
           }

           
           fatalError("Failed to get expected supplementary reusable view from collection view. Stopping the program execution")
       }

       return dataSource
   }
   func applySnapshot(append data: [DataModel], to section: Sections) {
       var snapshot = dataSource.snapshot()
       if snapshot.numberOfSections == 3 {
           snapshot.deleteAllItems()
           snapshot.appendSections([section])
       } else {
           snapshot.appendSections([section])
       }
       snapshot.appendItems(data, toSection: section)
       
       dataSource.apply(snapshot)   }
}
//MARK: - UICollectionViewLayout
extension ViewViewController {
    func genereteLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int,
        layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let sectionType = Sections.allCases[sectionIndex]
            
            switch sectionType {
            case .weatherNow: return self.generateWeatherNowLayout()
            case .forecastForDay: return self.generateForecastForDayLayout()
            case .weeklyForecast: return self.generateWeeklyForecastLayout()
            }
        }

        layout.register(SectionBGView.self, forDecorationViewOfKind: Identifiers.sectionBGView.rawValue)
        return layout
    }
    func generateWeatherNowLayout() -> NSCollectionLayoutSection {
        //Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 20, leading: 0, bottom: 0, trailing: 0)
        
        //Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(160))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        //Section
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    func generateForecastForDayLayout() -> NSCollectionLayoutSection {
        //Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 8, leading: 25, bottom: 8, trailing: 5)
      
        //Group
        let groupSize: NSCollectionLayoutSize = NSCollectionLayoutSize(widthDimension: .absolute(80), heightDimension: .absolute(140))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        //Section
        let section = NSCollectionLayoutSection(group: group)
        
        section.orthogonalScrollingBehavior = .continuous
        section.decorationItems = [NSCollectionLayoutDecorationItem.background(elementKind: Identifiers.sectionBGView.rawValue)]
        section.decorationItems.first?.contentInsets = .init(top: 10, leading: 10, bottom: 10, trailing: 10)
        return section
    }
    func generateWeeklyForecastLayout() -> NSCollectionLayoutSection {
        //Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 25, bottom: 0, trailing: 5)
        //Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        //Section
        let section = NSCollectionLayoutSection(group: group)
        section.decorationItems = [NSCollectionLayoutDecorationItem.background(elementKind: Identifiers.sectionBGView.rawValue)]
        section.decorationItems.first?.contentInsets = .init(top: 10, leading: 10, bottom: 10, trailing: 10)
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: Identifiers.headerElementKind.rawValue, alignment: .top)
        header.contentInsets = .init(top: 0, leading: 15, bottom: 0, trailing: 5)
        // this activates the "sticky" behavior
        header.pinToVisibleBounds = true
        section.boundarySupplementaryItems = [header]
        return section
    }

}
