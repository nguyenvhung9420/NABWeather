//
//  ListingCollectionViewCell.swift
//  NABWeather
//
//  Created by hungnguy on 4/2/22.
//

import UIKit
import Kingfisher

class ListingCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var mainImageView: UIImageView!
    
    @IBOutlet weak var weatherIconImageVIew: UIImageView!
    
    @IBOutlet weak var mainLabel: UILabel!
    
    @IBOutlet weak var degreeLbl: UILabel!
    
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var photoFilterLayer: UIView!
    private var weatherItem: WeatherItem?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        weatherIconImageVIew.image = nil
    }
    
    func makeViews(weatherItem: WeatherItem) {
        self.weatherItem = weatherItem
        
        var dateString: String = ""
        
        if Calendar.current.isDateInToday(weatherItem.date) {
            dateString = "Today"
        } else if Calendar.current.isDateInThisWeek(weatherItem.date) {
            dateString = weatherItem.weekday
        } else {
            dateString = weatherItem.dateString
        }
        
        mainLabel?.text = dateString
        mainLabel.numberOfLines = 2
        degreeLbl?.text = weatherItem.averageTempString
        descLabel?.text = weatherItem.description?.uppercased()
        descLabel.numberOfLines = 2
        
        mainLabel.layer.shadowColor = UIColor.black.cgColor
        mainLabel.layer.shadowRadius = 12
        mainLabel.layer.shadowOpacity = 1
        mainLabel.layer.shadowOffset = CGSize(width: 2, height: 2)
        mainLabel.layer.masksToBounds = false
        
        descLabel.layer.shadowColor = UIColor.black.cgColor
        descLabel.layer.shadowRadius = 12
        descLabel.layer.shadowOpacity = 1
        descLabel.layer.shadowOffset = CGSize(width: 2, height: 2)
        descLabel.layer.masksToBounds = false
        
        degreeLbl.layer.shadowColor = UIColor.black.cgColor
        degreeLbl.layer.shadowRadius = 12
        degreeLbl.layer.shadowOpacity = 0.6
        degreeLbl.layer.shadowOffset = CGSize(width: 2, height: 2)
        degreeLbl.layer.masksToBounds = false
        
        
        weatherIconImageVIew?.kf.setImage(with: RequestURL(type: .weatherIcon).getURL(params: [weatherItem.icon]))
        
        mainImageView.layer.cornerRadius = 16
        photoFilterLayer.layer.cornerRadius = 16
        mainImageView.image = getMainImage(weatherItem: weatherItem)
        mainImageView.contentMode = .scaleAspectFill
    }
    
    private func getMainImage(weatherItem: WeatherItem) -> UIImage {
         
//        let array: [String] = ["cloud", "rain", "clear","thunderstorm",  "default"]
//        return UIImage(named: array.randomElement()!)!
        
        let descString = weatherItem.description ?? ""
        if descString.contains("cloud") {
            return UIImage(named: "cloud")!
        }
        if descString.contains("rain") {
            return UIImage(named: "rain")!
        }
        if descString.contains("clear") || descString.contains("sky") {
            return UIImage(named: "clear")!
        }
        if descString.contains("thunderstorm") {
            return UIImage(named: "thunderstorm")!
        }
        return UIImage(named: "default")!
    }
    

}
