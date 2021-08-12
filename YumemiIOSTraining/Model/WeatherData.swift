//
//  WeatherData.swift
//  YumemiIOSTraining
//
//  Created by 今村京平 on 2021/08/07.
//

import Foundation

struct WeatherData: Codable {
    let max_temp: Int
    let min_temp: Int
    let weather: String
    let date: String
}
