import Foundation
import UIKit
import Network
import CoreLocation


class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var brickImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var info: UIButton!
    @IBOutlet weak var brickScroll: UIScrollView!
    @IBOutlet weak var noticeNetwork: UILabel!
    
    
    private var results = [WeatherResult]()
    let apiManager = WeatherService()
    let networkWeatherManager = NetworkWeatherManager()
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
        
        networkWeatherManager.monitorNetwork(unsatisfied: {
            self.unsatisfiedOutletProperties()
        }, satisfied: {
            self.noticeNetwork.isHidden = true
            self.getLocation()
        })
    }
    
     @objc
     private func refresh(sender: UIRefreshControl) {

         networkWeatherManager.monitorNetwork(unsatisfied: {
             self.unsatisfiedOutletProperties()
         }, satisfied: {
             self.noticeNetwork.isHidden = true
             self.getLocation()
         })
     }
     
    func unsatisfiedOutletProperties() {
        self.brickImageView.image = UIImage(named: "empty")
        self.noticeNetwork.isHidden = false
        self.brickScroll.refreshControl?.endRefreshing()
    }
  

    func getLocation() {
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
        apiManager.weatherURL { result in
            DispatchQueue.main.async {
                switch result {
                case .Success(let weatherConditions):
                    self.brickImageView.image = UIImage(named: weatherConditions.icon)
                    self.conditionLabel.text = weatherConditions.generalDescription
                    self.temperatureLabel.text = "\(Int(round(weatherConditions.temperature)))º"
                    self.locationLabel.text = weatherConditions.city
                case .Error(let string):
                    self.brickImageView.image = UIImage(named: "empty")
                    self.conditionLabel.text = "Error fetching data"
                    self.temperatureLabel.text = "Error fetching data"
                    self.locationLabel.text = "Error fetching data"
                    
                }
            }
        }
        
        self.locationManager.stopUpdatingLocation()
        
        DispatchQueue.main.async {
            self.brickScroll.refreshControl?.endRefreshing()
        }
    }
    

    
    
    
    @IBAction func infoButton(_ sender: UIButton) {
        let modalViewController = storyboard?.instantiateViewController(withIdentifier: "modalVC") as! ModalViewController
        modalViewController.modalPresentationStyle = .pageSheet
        present(modalViewController, animated: true, completion: nil)
        
    }
}

