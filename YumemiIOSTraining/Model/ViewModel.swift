//
//  ViewModel.swift
//  YumemiIOSTraining
//
//  Created by 今村京平 on 2021/08/12.
//

import Foundation
import YumemiWeather

protocol WeatherModel {
    func fetchWeather(alertMessage: (String) -> Void) -> WeatherData?
}

final class WeatherModelImpl: WeatherModel {
    
    func fetchWeather(alertMessage: (String) -> Void) -> WeatherData? {
        do {
            guard let jsonString = encodeFetchWeatherParameter(
                    area: "tokyo", date: Date()) else { return nil }
            let jsonStringWeather = try YumemiWeather.fetchWeather(jsonString)
            guard let weatherData = decodeFetchWeatherReturns(
                    jsonString: jsonStringWeather) else { return nil }
            return weatherData
        } catch {
            switch error {
            case YumemiWeatherError.invalidParameterError:
                alertMessage("無効なパラメータエラーです。")
                return nil
            case YumemiWeatherError.unknownError:
                alertMessage("不明なエラーです。")
                return nil
            default:
                fatalError()
            }
        }
    }
    
    private func encodeFetchWeatherParameter(area: String, date: Date) -> String? {
        let fetchWeatherParameter = FetchWeatherParameter(area: area, date: date)
        let encoder = JSONEncoder()
        let encoded = try? encoder.encode(fetchWeatherParameter)
        guard let encoded = encoded else { return nil }
        let jsonString = String(data: encoded, encoding: .utf8)
        return jsonString
    }
    
    private func decodeFetchWeatherReturns(jsonString: String) -> WeatherData?{
        let decoder = JSONDecoder()
        guard let jsonData = jsonString.data(using: .utf8) else { return nil }
        guard let weatherData = try? decoder.decode(
                WeatherData.self, from: jsonData) else { return nil }
        return weatherData
    }
}
