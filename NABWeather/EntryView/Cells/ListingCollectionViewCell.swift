//
//  ListingCollectionViewCell.swift
//  NABWeather
//
//  Created by hungnguy on 4/2/22.
//

import UIKit

class ListingCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var mainImageView: UIImageView!
    
    @IBOutlet weak var weatherIconImageVIew: UIImageView!
    
    @IBOutlet weak var mainLabel: UILabel!
    
    @IBOutlet weak var degreeLbl: UILabel!
    
    private var weatherItem: WeatherItem
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeViews(weatherItem: WeatherItem) {
        self.weatherItem = weatherItem
        mainLabel.text = weatherItem.description
        degreeLbl.text = weatherItem.averageTempString
    }

}
