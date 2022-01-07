
import Foundation

struct WeatherConditions {
    var city: String
    var temperature: Double
    var icon: String
    var generalDescription: String
}

enum WeatherResult {
    case Success(WeatherConditions)
    case Error(String)
}
