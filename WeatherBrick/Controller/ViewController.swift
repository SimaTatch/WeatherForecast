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
    
    let networkWeatherManager = NetworkWeatherManager()
    let apiRequest = APIRequest()
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
            self.startUpdatingLocation()
        })
    }
    

    @objc
    private func refresh(sender: UIRefreshControl) {
        
        networkWeatherManager.monitorNetwork(unsatisfied: {
            self.unsatisfiedOutletProperties()
        }, satisfied: {
            self.startUpdatingLocation()
        })
    }
    
    
    func unsatisfiedOutletProperties() {
        self.brickImageView.image = UIImage(named: "empty")
        self.noticeNetwork.isHidden = false
        self.brickScroll.refreshControl?.endRefreshing()
    }
  
//    проверяет покдлючение к сети
    
//    func monitorNetwork() {
//        let monitor = NWPathMonitor()
//        monitor.pathUpdateHandler = { path in
//            if path.status == .satisfied {
//                DispatchQueue.main.async {
//                    self.startUpdatingLocation()
//                }
//            } else {
//                DispatchQueue.main.async {
//                    self.brickImageView.image = UIImage(named: "empty")
//                    self.noticeNetwork.isHidden = false
//                    self.brickScroll.refreshControl?.endRefreshing()
//                }
//            }
//        }
//        let queue = DispatchQueue(label: "Network")
//        monitor.start(queue: queue)
//    }
    
    
    func startUpdatingLocation() {
        self.locationManager.requestWhenInUseAuthorization()
        if(CLLocationManager.locationServicesEnabled()){
        self.noticeNetwork.isHidden = true
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.startUpdatingLocation()
        }
    }
    
 

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        lat = location.coordinate.latitude
        lon = location.coordinate.longitude
            apiRequest.makeRequest { jsonResponce in
            let jsonWeather = jsonResponce["weather"].array![0]
            let jsonTemperature = jsonResponce["main"]
            let iconName = jsonWeather["icon"].stringValue
            
            self.locationLabel.text = jsonResponce["name"].stringValue
            self.brickImageView.image = UIImage(named: iconName)
            self.conditionLabel.text = jsonWeather["main"].stringValue
            self.temperatureLabel.text = "\(Int(round(jsonTemperature["temp"].doubleValue)))º"
        } failure: { error in
            print(error)
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

