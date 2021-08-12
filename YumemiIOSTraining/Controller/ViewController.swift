//
//  ViewController.swift
//  YumemiIOSTraining
//
//  Created by 今村京平 on 2021/08/04.
//

import UIKit
import YumemiWeather

final class ViewController: UIViewController {

    private var weatherModel: WeatherModel?

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
        weatherModel = WeatherModelImpl()
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
        guard let weatherData = weatherModel?.fetchWeather( alertMessage: { [weak self] in
            self?.presentAlertController(message: $0)
        }) else { return }
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

    @IBAction func didTapCloseButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

