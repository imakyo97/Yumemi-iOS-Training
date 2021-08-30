//
//  YumemiIOSTrainingUITests.swift
//  YumemiIOSTrainingUITests
//
//  Created by 今村京平 on 2021/08/27.
//

import XCTest

@testable import YumemiIOSTraining

class YumemiIOSTrainingUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
    }

    func xtestExample() throws {
    }

    func xtestLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
