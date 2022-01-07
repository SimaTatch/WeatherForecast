
import Foundation


fileprivate let apiKey = "df801cce69d6a983348608344a2a8453"
var lon = 30.308611
var lat = 59.937500


class WeatherService {
    
    
    func weatherURL(completionHandler: @escaping (WeatherResult) -> Void) {
        let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completionHandler(.Error(error.localizedDescription))
                return
            }
            guard let data = data else {
                completionHandler(.Error("No data received"))
                return
            }
            completionHandler(self.weather(fromJsonData: data))
        }
        task.resume()
    }
    
    func weather(fromJsonData data: Data) -> WeatherResult {
        let raw = try? JSONSerialization.jsonObject(with: data, options: [])
        guard let json = raw as? [String: AnyObject],
              
              let weather = json["weather"] as? [AnyObject],
              let descriptionObj = weather[0] as? [String: AnyObject],
              let description = descriptionObj["main"] as? String,
              let icon = descriptionObj["icon"] as? String,
              let main = json["main"],
              let temperature = main["temp"] as? Double,
              let city = json["name"] as? String
        else {
            return .Error("Malformed JSON response")
        }
        
        return .Success(WeatherConditions(city: city , temperature: temperature, icon: icon, generalDescription: description))
        
    }
    
}
