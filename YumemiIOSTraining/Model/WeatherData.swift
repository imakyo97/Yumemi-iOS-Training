//
//  WeatherData.swift
//  YumemiIOSTraining
//
//  Created by 今村京平 on 2021/08/07.
//

import Foundation

struct WeatherData: Codable {
    let maxTemp: Int
    let minTemp: Int
    let weather: String
    let date: String

    enum CodingKeys : String, CodingKey {
        case maxTemp = "max_temp"
        case minTemp = "min_temp"
        case weather
        case date
    }
}
