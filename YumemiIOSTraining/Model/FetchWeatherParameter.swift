//
//  FetchWeatherParameter.swift
//  YumemiIOSTraining
//
//  Created by 今村京平 on 2021/08/08.
//

import Foundation

struct FetchWeatherParameter: Codable {
    let area: String
    let date: String

    init(area: String, date: Date) {
        self.area = area
        self.date = convertingFromDateToString(date: date)

        func convertingFromDateToString(date: Date) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
            let stringDate = dateFormatter.string(from: date)
            return stringDate
        }
    }
}
