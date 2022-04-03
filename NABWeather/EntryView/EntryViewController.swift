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
    
    
    private var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad() 
        prepareCollectionViewCell()
        fetchWeatherList()
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
                let screenWidth = (UIScreen.main.bounds.width - 32) / 2 - 8
        layout.itemSize = CGSize(width: screenWidth, height: screenWidth)
        listingCollectionView.delegate = self
        listingCollectionView.dataSource = self
        listingCollectionView.register(UINib(nibName: "ListingCollectionViewCell",
                                             bundle: nil), forCellWithReuseIdentifier: collectionCellId)
        listingCollectionView.setCollectionViewLayout(layout, animated: true)
        listingCollectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
        listingCollectionView.reloadData()
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
        return 16
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
            let height = (view.frame.width) * 9 / 16
            return CGSize(width: view.frame.width - 32, height: (UIScreen.main.bounds.width - 32) / 2 - 8)
        }
        
       
        let screenWidth = (UIScreen.main.bounds.width - 32) / 2 - 8
        return CGSize(width: screenWidth, height: screenWidth)
    }
}
