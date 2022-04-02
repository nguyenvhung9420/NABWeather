//
//  ViewController.swift
//  NABWeather
//
//  Created by hungnguy on 4/2/22.
//

import UIKit
import RxSwift
import RxCocoa

class EntryViewController: UIViewController {
    
    @IBOutlet weak var listingCollectionView: UICollectionView!
    
    private var collectionCellId: String = "listing_cell_id"
    private var viewModel = EntryViewModel()
    
    private var disposed = DisposeBag()
    
    private var items: [WeatherItem] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchWeatherList()
        
        // Do any additional setup after loading the view.
    }
    
    private func fetchWeatherList() {
        
        viewModel.getWeatherList(failure: { error in
            print("error = \(error.message)")
        })
        
        viewModel.weatherItems
            .subscribeOn(MainScheduler.instance)
            .observeOn(MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] items in
                    guard let self = self else { return }
                    
                    
                    print("items = \(items)")
                    self.items  = items
//                    self.productTableView.reloadData {
//                        self.productTableView.finishInfiniteScroll()
//                    }
//                    self.tableViewFooter?.isHidden = true
//                    self.refreshControl.endRefreshing()
//                    switch self.viewModel.selectedTabTypeData.value {
//                    case .all:
//                        self.productLabel.text = "\("_insights".localized()) (\(self.viewModel.insightResponse.isOffline ? response.count.string : self.viewModel.insightResponse.totalCount))".uppercased()
//                    case .popular:
//                        self.productLabel.text = "\("_insights".localized()) (\(self.viewModel.insightResponse.isOffline ? response.count : self.viewModel.insightResponse.items.count))".uppercased()
//                    }
                    
                }, onError: { [weak self] error in
                    print("error when subscribe = \(error)")
                }, onCompleted: {
                }).disposed(by: disposed)
    }
    
    private func prepareCollectionViewCell () {
        let layout = UICollectionViewLayout()
        listingCollectionView.register(ListingCollectionViewCell.self, forCellWithReuseIdentifier: collectionCellId)
        listingCollectionView.delegate = self
        listingCollectionView.dataSource = self
        listingCollectionView.setCollectionViewLayout(layout, animated: true, completion: nil)
    }

}

extension EntryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.collectionCellId, for: indexPath) as! ListingCollectionViewCell
        cell.makeViews(weatherItem: items[indexPath.item])
        return cell
    }
    
     
}
