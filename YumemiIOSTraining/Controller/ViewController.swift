//
//  ViewController.swift
//  YumemiIOSTraining
//
//  Created by 今村京平 on 2021/08/04.
//

import UIKit
import YumemiWeather

final class ViewController: UIViewController {

    @IBOutlet private weak var weatherImageView: UIImageView!
    @IBOutlet private weak var minTempLabel: UILabel!
    @IBOutlet private weak var maxTempLabel: UILabel!

    enum Weather {
        static let sunny = "sunny"
        static let cloudy = "cloudy"
        static let rainy = "rainy"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        settingWillEnterForegroundObserver()
    }

    private func settingWillEnterForegroundObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleNotification(_:)),
            name: UIApplication.willEnterForegroundNotification,
            object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func handleNotification(_ notification: Notification) {
        showWeather()
    }

    @IBAction func didTapReloadButton(_ sender: Any) {
        showWeather()
    }

    private func showWeather() {
        do {
            guard let jsonString = encodeFetchWeatherParameter(
                    area: "tokyo", date: Date()) else { return }
            let jsonStringWeather = try YumemiWeather.fetchWeather(jsonString)
            guard let weatherData = decodeFetchWeatherReturns(
                    jsonString: jsonStringWeather) else { return }
            maxTempLabel.text = String(weatherData.max_temp)
            minTempLabel.text = String(weatherData.min_temp)
            switch weatherData.weather {
            case Weather.sunny:
                let sunnyImage = UIImage(named: Weather.sunny)
                weatherImageView.image = sunnyImage
                weatherImageView.tintColor = .red
            case Weather.cloudy:
                let cloudyImage = UIImage(named: Weather.cloudy)
                weatherImageView.image = cloudyImage
                weatherImageView.tintColor = .gray
            case Weather.rainy:
                let rainyImage = UIImage(named: Weather.rainy)
                weatherImageView.image = rainyImage
                weatherImageView.tintColor = .blue
            default:
                return
            }
        } catch {
            switch error {
            case YumemiWeatherError.invalidParameterError:
                presentAlertController(message: "無効なパラメータエラーです。")
            case YumemiWeatherError.unknownError:
                presentAlertController(message: "不明なエラーです")
            default:
                fatalError()
            }
        }
    }

    private func presentAlertController(message: String) {
        let alert = UIAlertController(
            title: "読み込みに失敗しました。",
            message: nil,
            preferredStyle: .alert
        )
        let action = UIAlertAction(
            title: "OK",
            style: .default,
            handler: nil
        )
        alert.message = message
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
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

    @IBAction func didTapCloseButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

