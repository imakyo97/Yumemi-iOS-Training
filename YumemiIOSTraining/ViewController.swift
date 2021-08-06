//
//  ViewController.swift
//  YumemiIOSTraining
//
//  Created by 今村京平 on 2021/08/04.
//

import UIKit
import YumemiWeather

class ViewController: UIViewController {

    @IBOutlet private weak var weatherImageView: UIImageView!

    enum Weather {
        static let sunny = "sunny"
        static let cloudy = "cloudy"
        static let rainy = "rainy"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func didTapReloadButton(_ sender: Any) {
        do {
            let stringWeather = try YumemiWeather.fetchWeather(at: "tokyo")
            switch stringWeather {
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
}

