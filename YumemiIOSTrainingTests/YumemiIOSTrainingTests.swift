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

        let viewController = instantiateViewController(
            weatherModel: MockWeatherModel(weather: sunny)
        )
        viewController.loadViewIfNeeded()

        let reloadButton: UIButton = fetchReloadButton(from: viewController)
        reloadButton.sendActions(for: .touchUpInside)

        let weatherImage: UIImage = fetchWeatherImage(from: viewController)
        let sunnyImage: UIImage = UIImage(named: sunny)!
        XCTAssertEqual(weatherImage, sunnyImage, "画面に晴れ画像が表示されること")
    }

    func testShowCloudy() {
        let cloudy = "cloudy"

        let viewController = instantiateViewController(
            weatherModel: MockWeatherModel(weather: cloudy)
        )
        viewController.loadViewIfNeeded()

        let reloadButton: UIButton = fetchReloadButton(from: viewController)
        reloadButton.sendActions(for: .touchUpInside)

        let weatherImage: UIImage = fetchWeatherImage(from: viewController)
        let cloudyImage: UIImage = UIImage(named: cloudy)!
        XCTAssertEqual(weatherImage, cloudyImage, "画面に曇り画像が表示されること")
    }

    func testShowRainy() {
        let rainy = "rainy"

        let viewController = instantiateViewController(
            weatherModel: MockWeatherModel(weather: rainy)
        )
        viewController.loadViewIfNeeded()

        let reloadButton: UIButton = fetchReloadButton(from: viewController)
        reloadButton.sendActions(for: .touchUpInside)

        let weatherImage: UIImage = fetchWeatherImage(from: viewController)
        let rainyImage: UIImage = UIImage(named: rainy)!
        XCTAssertEqual(weatherImage, rainyImage, "画面に雨画像が表示されること")
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

        let tempLabels: [String : UILabel] =
            fetchTempLabe(from: viewController)
        XCTAssertEqual(tempLabels["minTempLabel"]?.text,
                       String(mockWeatherModel.minTemp),
                       "天気予報の最低気温がUILabelに反映されること")
        XCTAssertEqual(tempLabels["maxTempLabel"]?.text,
                       String(mockWeatherModel.maxTemp),
                       "天気予報の最高気温がUILabelに反映されること")
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
            .filter { $0.titleLabel?.text == "Reload" }.first!
    }

    private func fetchWeatherImage(from vc: ViewController) -> UIImage {
        let stackView: UIStackView = vc.view.subviews
            .first(where: { $0 is UIStackView } ) as! UIStackView
        let imageView: UIImageView = stackView.subviews
            .first(where: { $0 is UIImageView} ) as! UIImageView
        return imageView.image!
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
            .filter { $0.restorationIdentifier == "minTempLabel"}.first!
        let maxTempLabel: UILabel = stackViewInStackView.subviews
            .compactMap { $0 as? UILabel }
            .filter { $0.restorationIdentifier == "maxTempLabel"}.first!
        return tempLabels
    }
}

final class MockWeatherModel: WeatherModel {

    private let weatherData: WeatherData

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

    func fetchWeather(alertMessage: (String) -> Void) -> WeatherData? {
        return weatherData
    }
}
