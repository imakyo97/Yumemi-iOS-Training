//
//  ViewModel.swift
//  YumemiIOSTraining
//
//  Created by 今村京平 on 2021/08/12.
//

import Foundation
import YumemiWeather

protocol WeatherModel {
    func fetchWeather(weatherData: @escaping (WeatherData) -> (),
                      alertMessage: @escaping (String) -> ())
}

final class WeatherModelImpl: WeatherModel {
    func fetchWeather(weatherData: @escaping (WeatherData) -> (),
                      alertMessage: @escaping (String) -> ()) {
        DispatchQueue.global(qos: .userInitiated).sync {
            do {
                guard let jsonString = encodeFetchWeatherParameter(
                        area: "tokyo", date: Date()) else { return }
                let jsonStringWeather = try YumemiWeather.syncFetchWeather(jsonString)
                guard let data = self.decodeFetchWeatherReturns(jsonString: jsonStringWeather) else { return }
                weatherData(data)
            } catch {
                switch error {
                case YumemiWeatherError.invalidParameterError:
                    alertMessage("無効なパラメーターです")
                case YumemiWeatherError.unknownError:
                    alertMessage("不明なエラーです")
                default:
                    fatalError()
                }
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
