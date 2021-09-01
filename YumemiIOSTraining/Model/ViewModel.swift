//
//  ViewModel.swift
//  YumemiIOSTraining
//
//  Created by 今村京平 on 2021/08/12.
//

import Foundation
import YumemiWeather

protocol WeatherModel {
    func fetchWeather()
    var delegate: WeatherModelDelegate? { get set }
}

protocol WeatherModelDelegate: AnyObject {
    func fetchedWeather(weatherData: WeatherData)
    func presentAlertMessage(alertMessage: String)
}

final class WeatherModelImpl: WeatherModel {

    weak var delegate: WeatherModelDelegate?
    
    func fetchWeather() {
        guard let jsonString = encodeFetchWeatherParameter(
                area: "tokyo", date: Date()) else { return }
        DispatchQueue.global(qos: .userInitiated).sync {
            do {
                let jsonStringWeather = try YumemiWeather.syncFetchWeather(jsonString)
                guard let weatherData = self.decodeFetchWeatherReturns(jsonString: jsonStringWeather) else { return }
                DispatchQueue.main.async {
                    self.delegate?.fetchedWeather(weatherData: weatherData)
                }
            } catch {
                DispatchQueue.main.async {
                    switch error {
                    case YumemiWeatherError.invalidParameterError:
                        self.delegate?.presentAlertMessage(alertMessage: "無効なパラメータエラーです")
                    case YumemiWeatherError.unknownError:
                        self.delegate?.presentAlertMessage(alertMessage: "不明なエラーです")
                    default:
                        fatalError()
                    }
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
