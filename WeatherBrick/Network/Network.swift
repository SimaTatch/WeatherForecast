
import Foundation
import Network

struct Network {
    
    var location = Location()
    var vc = ViewController()
    
    public func monitorNetwork() {
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                DispatchQueue.main.async {
                    if  self.vc.brickScroll.refreshControl?.isRefreshing != true {
                        self.vc.noticeNetwork.isHidden = true
                        self.location.managerStartUpdatingLocation()
                        } else {
                        self.vc.noticeNetwork.isHidden = true
                        self.location.locationManager.startUpdatingLocation()
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.vc.noticeNetwork.isHidden = false
                    self.vc.noticeNetwork.text = "No Internet connection"
                    self.vc.brickScroll.refreshControl?.endRefreshing()
                }
            }
        }
        let queue = DispatchQueue(label: "Network")
        monitor.start(queue: queue)
    }
}





