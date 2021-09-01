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
    private let activityIndicatorView = UIActivityIndicatorView()

    enum Weather {
        static let sunny = "sunny"
        static let cloudy = "cloudy"
        static let rainy = "rainy"
    }

    init?(coder: NSCoder, weatherModel: WeatherModel) {
        self.weatherModel = weatherModel
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherModel?.delegate = self
        settingWillEnterForegroundObserver()
        setupActivityIndicatorView()
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
        print("ViewControllerが閉じました")
    }

    @objc private func handleNotification(_ notification: Notification) {
        showWeather()
    }

    @IBAction func didTapReloadButton(_ sender: Any) {
        showWeather()
    }

    private func setupActivityIndicatorView() {
        activityIndicatorView.center = view.center
        activityIndicatorView.style = .medium
        activityIndicatorView.color = .gray
        view.addSubview(activityIndicatorView)
    }

    private func showWeather() {
        activityIndicatorView.startAnimating()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            self.weatherModel?.fetchWeather()
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.activityIndicatorView.stopAnimating()
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

    @IBAction func didTapCloseButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension ViewController: WeatherModelDelegate {
    func fetchedWeather(weatherData: WeatherData) {
        self.maxTempLabel.text = String(weatherData.maxTemp)
        self.minTempLabel.text = String(weatherData.minTemp)
        switch weatherData.weather {
        case Weather.sunny:
            let sunnyImage = UIImage(named: Weather.sunny)
            self.weatherImageView.image = sunnyImage
            self.weatherImageView.tintColor = .red
        case Weather.cloudy:
            let cloudyImage = UIImage(named: Weather.cloudy)
            self.weatherImageView.image = cloudyImage
            self.weatherImageView.tintColor = .gray
        case Weather.rainy:
            let rainyImage = UIImage(named: Weather.rainy)
            self.weatherImageView.image = rainyImage
            self.weatherImageView.tintColor = .blue
        default:
            fatalError()
        }
    }

    func presentAlertMessage(alertMessage: String) {
        presentAlertController(message: alertMessage)
    }
}

