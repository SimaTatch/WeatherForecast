
import Network
import Foundation

struct NetworkWeatherManager {
    
func monitorNetwork( unsatisfied: @escaping ()->(), satisfied: @escaping ()->()) {
    let monitor = NWPathMonitor()
    monitor.pathUpdateHandler = { path in
        if path.status == .satisfied {
            DispatchQueue.main.async {
                satisfied()
            }
        } else {
            DispatchQueue.main.async {
                unsatisfied()
            }
        }
    }
    let queue = DispatchQueue(label: "Network")
    monitor.start(queue: queue)
}
    
}

