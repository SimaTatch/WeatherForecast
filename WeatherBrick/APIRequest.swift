//
//  APIRequest.swift
//  WeatherBrick
//
//  Created by Серафима  Татченкова  on 04.01.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import Alamofire
import SwiftyJSON
import Foundation

struct APIRequest {
    
    func makeRequest( completion: @escaping ((JSON) -> Void), failure: @escaping (Error) -> Void) {
        AF.request("http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric").responseData
        { response in
            switch response.result {
            case .success(let value):
                let jsonResponce = JSON(value)
                let jsonWeather = jsonResponce["weather"].array![0]
                let jsonTemperature = jsonResponce["main"]
                let iconName = jsonWeather["icon"].stringValue
                completion(jsonResponce)
            case .failure(let error):
                failure(error)
            }
        }
    }
}
