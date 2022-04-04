//
//  ViewController.swift
//  NABWeather
//
//  Created by hungnguy on 4/2/22.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftUI

class EntryViewController: UIViewController {
    
    @IBOutlet weak var listingCollectionView: UICollectionView!
    
    private var collectionCellId: String = "listing_cell_id"
    private var viewModel = EntryViewModel()
    
    private var disposed = DisposeBag()
    
    private var items: [WeatherItem] = []
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet var searchBarView: UISearchBar!
    private var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDefaults.standard.set("imperial", forKey: Constant.metricKey)
        prepareCollectionViewCell()
        fetchWeatherList()
        
        self.title = Constant.beginningCityName.capitalized
        navigationController?.navigationBar.prefersLargeTitles = true
        prepareSearchController()
        
        var buttonLabel = ""
        if UserDefaults.standard.string(forKey: Constant.metricKey) == "imperial" {
            buttonLabel = "°F"
        } else {
            buttonLabel = "°C"
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: buttonLabel, style: .plain, target: self, action: #selector(displayActionSheet))
    }
    
    private func fetchWeatherList() {
        
        viewModel.getWeatherList(count: 10, city: "saigon", failure: { error in
            print("error = \(error.message)")
        })
        
        viewModel.weatherItems
            .subscribeOn(MainScheduler.instance)
            .observeOn(MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] items in
                    guard let self = self else { return }
                     
                    self.items  = items
                    self.listingCollectionView.reloadData()
                    
                }, onError: { [weak self] error in
                    print("error when subscribe = \(error)")
                }, onCompleted: {
                }).disposed(by: disposed)
    }
    
    private func prepareCollectionViewCell () {
        let layout = UICollectionViewFlowLayout()
        let screenWidth = (UIScreen.main.bounds.width - Constant.defaultInsetVal*2) / 2 - Constant.defaultInsetVal/2
        layout.itemSize = CGSize(width: screenWidth, height: screenWidth)
        listingCollectionView.delegate = self
        listingCollectionView.dataSource = self
        listingCollectionView.register(UINib(nibName: "ListingCollectionViewCell",
                                             bundle: nil), forCellWithReuseIdentifier: collectionCellId)
        listingCollectionView.setCollectionViewLayout(layout, animated: true)
        listingCollectionView.contentInset = UIEdgeInsets(top: 0,
                                                          left: Constant.defaultInsetVal,
                                                          bottom: Constant.defaultInsetVal,
                                                          right: Constant.defaultInsetVal)
        listingCollectionView.reloadData()
    }
    
    private func prepareSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search city, like 'Paris'"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.delegate = self

    }
}

extension EntryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("items.count = \(items.count)")
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("cell.makeViews")
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.collectionCellId, for: indexPath) as? ListingCollectionViewCell else { return UICollectionViewCell() }
        cell.makeViews(weatherItem: items[indexPath.item])
        print("cell.makeViews")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constant.defaultInsetVal
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.item
        listingCollectionView.performBatchUpdates( {
            self.listingCollectionView.reloadSections(IndexSet(integer: 0))
        }, completion: { (finished:Bool) -> Void in
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == selectedIndex {
            return CGSize(width: view.frame.width - Constant.defaultInsetVal*2,
                          height: (UIScreen.main.bounds.width - Constant.defaultInsetVal*2) / 2 - Constant.defaultInsetVal/2)
        }
        let screenWidth = (UIScreen.main.bounds.width - Constant.defaultInsetVal*2) / 2 - Constant.defaultInsetVal/2
        return CGSize(width: screenWidth, height: screenWidth)
    }
}

extension EntryViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        if (searchBar.text ?? "").count < 3 { return }
        self.title = (searchBar.text ?? "")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.viewModel.getWeatherList(count: 10, city: searchBar.text ?? "", failure: { error in
                if error.message.isEmpty { return }
                self.showToast(message: error.message.uppercased(), font: .systemFont(ofSize: 11.0, weight: .semibold))
            })
        }
    }
}
    
extension EntryViewController  {
    func showToast(message : String, font: UIFont) {
        let frame = CGRect(x: Constant.defaultInsetVal,
                           y:self.view.frame.size.height - 100,
                           width: self.view.frame.size.width - Constant.defaultInsetVal*2,
                           height: 35)
        let toastLabel = UILabel(frame: frame)
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 2.0, delay: 1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    @objc func displayActionSheet(_ sender: Any) {
          
        let optionMenu = UIAlertController(title: nil, message: "Choose Temperature Option", preferredStyle: .actionSheet)
             
        let deleteAction = UIAlertAction(title: "Imperial °F", style: .default, handler: { action in
            UserDefaults.standard.set("imperial", forKey: Constant.metricKey)
            self.rerenderButtonTemperature()
        })
        let saveAction = UIAlertAction(title: "Metric °C", style: .default, handler: { action in
            UserDefaults.standard.set("metric", forKey: Constant.metricKey)
            self.rerenderButtonTemperature()
        })
             
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
             
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(saveAction)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
        
    }
    
    private func rerenderButtonTemperature() {
        if UserDefaults.standard.string(forKey: Constant.metricKey) == "imperial" {
            navigationItem.rightBarButtonItem?.title = "°F"
        } else {
            navigationItem.rightBarButtonItem?.title = "°C"
        }
        viewModel.getWeatherList(count: 10, city: "saigon", failure: { error in
            print("error = \(error.message)")
        })
    }
}
