import Foundation
import UIKit
import Network
import Alamofire
import SwiftyJSON
import CoreLocation


class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var brickImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var info: UIButton!
    @IBOutlet weak var brickScroll: UIScrollView!
    @IBOutlet weak var noticeNetwork: UILabel!
    
    let locationManager = CLLocationManager()
    let myRefreshControl: UIRefreshControl = {
        let refreshControll = UIRefreshControl()
        refreshControll.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControll
    }()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noticeNetwork.isHidden = true
        info.setGradientLayer(colorsInOrder: Colors.colorsArray)
        brickScroll.refreshControl = myRefreshControl
        
        monitorNetwork()
    }

    @objc
    private func refresh(sender: UIRefreshControl) {
        monitorNetwork()
    }
    
    func monitorNetwork() {
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                DispatchQueue.main.async {
                    self.noticeNetwork.isHidden = true
                    self.managerStartUpdatingLocation()
                }
            } else {
                DispatchQueue.main.async {
                    self.noticeNetwork.isHidden = false
                    self.noticeNetwork.text = "No Internet connection"
                    self.brickScroll.refreshControl?.endRefreshing()
                }
            }
        }
        let queue = DispatchQueue(label: "Network")
        monitor.start(queue: queue)
    }
    
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
                
                self.locationLabel.text = jsonResponce["name"].stringValue
                self.brickImageView.image = UIImage(named: iconName)
                self.conditionLabel.text = jsonWeather["main"].stringValue
                self.temperatureLabel.text = "\(Int(round(jsonTemperature["temp"].doubleValue)))º"
            case .failure(let error):
                print(error)
            }
        }
        self.locationManager.stopUpdatingLocation()
        
        DispatchQueue.main.async {
            self.brickScroll.refreshControl?.endRefreshing()
        }
    }
    
    
    @IBAction func infoButton(_ sender: UIButton) {
        let modalViewController = storyboard?.instantiateViewController(withIdentifier: "modalVC") as! ModalViewController
        modalViewController.modalPresentationStyle = .fullScreen
        present(modalViewController, animated: true, completion: nil)
        
    }
}

