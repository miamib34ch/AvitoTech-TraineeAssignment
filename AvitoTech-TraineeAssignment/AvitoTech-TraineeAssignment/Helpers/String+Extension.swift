//
//  String+Extension.swift
//  AvitoTech-TraineeAssignment
//
//  Created by Богдан Полыгалов on 30.08.2023.
//

import Foundation

extension String {
    var formattedDate: String {
        let dateFormatter = DateFormatter()
        let inputDateFormat = "yyyy-MM-dd"
        let outputDateFormat = "d MMMM"

        dateFormatter.dateFormat = inputDateFormat
        guard let date = dateFormatter.date(from: self) else { return self }

        dateFormatter.dateFormat = outputDateFormat
        dateFormatter.locale = Locale.current
        let formattedDate = dateFormatter.string(from: date)
        return formattedDate
    }
}
