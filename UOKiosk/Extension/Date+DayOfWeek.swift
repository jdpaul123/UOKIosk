//
//  Date+DaysOfTheWeek.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 6/12/23.
//

import Foundation

extension Date {
    // First used in WhatIsOpenPlace init method and WhatIsOpenViewModel setUpTimer method
    // https://stackoverflow.com/questions/25533147/get-day-of-week-using-nsdate
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
        // or use capitalized(with: locale) if you want
    }
}
