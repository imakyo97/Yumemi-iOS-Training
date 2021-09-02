//
//  YumemiIOSTrainingTests.swift
//  YumemiIOSTrainingTests
//
//  Created by 今村京平 on 2021/08/27.
//

import XCTest

@testable import YumemiIOSTraining

class YumemiIOSTrainingTests: XCTestCase {

    func testShowSunny() {
        let sunny = "sunny"
        let mockWeatherModel = MockWeatherModel(weather: sunny)

        let viewController = instantiateViewController(
            weatherModel: mockWeatherModel
        )
        viewController.loadViewIfNeeded()

        let reloadButton: UIButton = fetchReloadButton(from: viewController)
        reloadButton.sendActions(for: .touchUpInside)

        let exp = expectation(description: "wait for finish")

        DispatchQueue.main.async {
            let weatherImageView: UIImageView = self.fetchWeatherImage(from: viewController)
            let sunnyImage: UIImage = UIImage(named: sunny)!
            XCTAssertEqual(weatherImageView.image, sunnyImage, "画面に晴れ画像が表示されること")
            exp.fulfill()
        }
        wait(for: [exp], timeout: 10)
    }

    func testShowCloudy() {
        let cloudy = "cloudy"
        let mockWeatherModel = MockWeatherModel(weather: cloudy)

        let viewController = instantiateViewController(
            weatherModel: mockWeatherModel
        )
        viewController.loadViewIfNeeded()

        let reloadButton: UIButton = fetchReloadButton(from: viewController)
        reloadButton.sendActions(for: .touchUpInside)

        let exp = expectation(description: "wait for finish")

        DispatchQueue.main.async {
            let weatherImageView: UIImageView = self.fetchWeatherImage(from: viewController)
            let cloudyImage: UIImage = UIImage(named: cloudy)!
            XCTAssertEqual(weatherImageView.image, cloudyImage, "画面に曇り画像が表示されること")
            exp.fulfill()
        }
        wait(for: [exp], timeout: 10)
    }

    func testShowRainy() {
        let rainy = "rainy"
        let mockWeatherModel = MockWeatherModel(weather: rainy)
        
        let viewController = instantiateViewController(
            weatherModel: mockWeatherModel
        )
        viewController.loadViewIfNeeded()

        let reloadButton: UIButton = fetchReloadButton(from: viewController)
        reloadButton.sendActions(for: .touchUpInside)

        let exp = expectation(description: "wait for finish")

        DispatchQueue.main.async {
            let weatherImageView: UIImageView = self.fetchWeatherImage(from: viewController)
            let rainyImage: UIImage = UIImage(named: rainy)!
            XCTAssertEqual(weatherImageView.image, rainyImage, "画面に雨画像が表示されること")
            exp.fulfill()
        }
        wait(for: [exp], timeout: 10)
    }

    func testShowTempLabelText() {
        let sunny = "sunny"
        let mockWeatherModel = MockWeatherModel(weather: sunny)

        let viewController = instantiateViewController(
            weatherModel: mockWeatherModel
        )
        viewController.loadViewIfNeeded()

        let reloadButton: UIButton =
            fetchReloadButton(from: viewController)
        reloadButton.sendActions(for: .touchUpInside)

        let exp = expectation(description: "wait for finish")

        DispatchQueue.main.async {
            let tempLabels: [String : UILabel] =
                self.fetchTempLabe(from: viewController)
            XCTAssertEqual(tempLabels["minTempLabel"]?.text,
                           String(mockWeatherModel.minTemp),
                           "天気予報の最低気温がUILabelに反映されること")
            XCTAssertEqual(tempLabels["maxTempLabel"]?.text,
                           String(mockWeatherModel.maxTemp),
                           "天気予報の最高気温がUILabelに反映されること")
            exp.fulfill()
        }
        wait(for: [exp], timeout: 10)
    }

    private func instantiateViewController(weatherModel: WeatherModel) -> ViewController {
        UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(
                identifier: "ViewController",
                creator: { coder in
                    ViewController(
                        coder: coder,
                        weatherModel: weatherModel
                    )
                })
    }

    private func fetchReloadButton(from vc: ViewController) -> UIButton {
        vc.view.subviews
            .compactMap { $0 as? UIButton }
            .first(where: { $0.restorationIdentifier == "ReloadButton" })!
    }

    private func fetchWeatherImage(from vc: ViewController) -> UIImageView {
        let stackView: UIStackView = vc.view.subviews
            .first(where: { $0 is UIStackView } ) as! UIStackView
        let imageView: UIImageView = stackView.subviews
            .first(where: { $0 is UIImageView }) as! UIImageView
        return imageView
    }

    private func fetchTempLabe(from vc: ViewController) -> [String: UILabel] {

        var tempLabels: [String: UILabel] {
            [
                "minTempLabel" : minTempLabel,
                "maxTempLabel" : maxTempLabel
            ]
        }

        let stackView: UIStackView = vc.view.subviews.first(where: { $0 is UIStackView  } ) as! UIStackView
        let stackViewInStackView: UIStackView = stackView.subviews.first(where: { $0 is UIStackView } ) as! UIStackView
        let minTempLabel: UILabel = stackViewInStackView.subviews
            .compactMap { $0 as? UILabel }
            .filter { $0.restorationIdentifier == "MinTempLabel"}.first!
        let maxTempLabel: UILabel = stackViewInStackView.subviews
            .compactMap { $0 as? UILabel }
            .filter { $0.restorationIdentifier == "MaxTempLabel"}.first!
        return tempLabels
    }
}

final class MockWeatherModel: WeatherModel {

    let weatherData: WeatherData

    let maxTemp: Int = 30
    let minTemp: Int = 25

    init(weather: String) {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        let stringDate = dateFormatter.string(from: date)
        weatherData = WeatherData(
            maxTemp: maxTemp,
            minTemp: minTemp,
            weather: weather, date: stringDate
        )
    }

    func fetchWeather(weatherData: @escaping (WeatherData) -> (),
                      alertMessage: @escaping (String) -> ()) {
        weatherData(self.weatherData)
    }
}
