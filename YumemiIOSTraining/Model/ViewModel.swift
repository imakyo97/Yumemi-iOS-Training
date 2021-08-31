//
//  ViewModel.swift
//  YumemiIOSTraining
//
//  Created by 今村京平 on 2021/08/12.
//

import Foundation
import YumemiWeather

protocol WeatherModel {
    func fetchWeather(alertMessage: @escaping (String) -> Void) -> WeatherData?
}

final class WeatherModelImpl: WeatherModel {
    
    func fetchWeather(alertMessage: @escaping (String) -> Void) -> WeatherData? {
        guard let jsonString = encodeFetchWeatherParameter(
                area: "tokyo", date: Date()) else { return nil }
        var jsonStringWeather: String?
        DispatchQueue.global(qos: .userInitiated).sync {
            do {
                jsonStringWeather = try YumemiWeather.syncFetchWeather(jsonString)
            } catch {
                DispatchQueue.main.async {
                switch error {
                case YumemiWeatherError.invalidParameterError:
                        alertMessage("無効なパラメータエラーです。")

                case YumemiWeatherError.unknownError:
                        alertMessage("不明なエラーです。")
                default:
                        fatalError()
                    }
                }
            }
        }
        let weatherData = decodeFetchWeatherReturns(jsonString: jsonStringWeather ?? "")
        return weatherData
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
