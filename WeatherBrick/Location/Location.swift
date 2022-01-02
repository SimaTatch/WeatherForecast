import Alamofire
import SwiftyJSON
import Foundation
import CoreLocation

class Location: NSObject, CLLocationManagerDelegate {
    
    let apiKey = "df801cce69d6a983348608344a2a8453"
    var lat = 11.344533
    var lon = 104.33322
    let locationManager = CLLocationManager()
    var vc = ViewController()
    
    func managerStartUpdatingLocation() {
        self.locationManager.requestWhenInUseAuthorization()
        if(CLLocationManager.locationServicesEnabled()){
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        lat = location.coordinate.latitude
        lon = location.coordinate.longitude
        AF.request("http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric").responseData
        { response in
            switch response.result {
            case .success(let value):
                let jsonResponce = JSON(value)
                let jsonWeather = jsonResponce["weather"].array![0]
                let jsonTemperature = jsonResponce["main"]
                let iconName = jsonWeather["icon"].stringValue
                
                self.vc.locationLabel.text = jsonResponce["name"].stringValue
                self.vc.brickImageView.image = UIImage(named: iconName)
                self.vc.conditionLabel.text = jsonWeather["main"].stringValue
                self.vc.temperatureLabel.text = "\(Int(round(jsonTemperature["temp"].doubleValue)))º"
            case .failure(let error):
                print(error)
            }
        }
        self.locationManager.stopUpdatingLocation()
        
        DispatchQueue.main.async {
            self.vc.brickScroll.refreshControl?.endRefreshing()
        }
    }
    
}
