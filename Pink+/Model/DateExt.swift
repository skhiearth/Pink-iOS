//
//  Date.swift
//  Pink+
//
//  Created by Utkarsh Sharma on 24/09/20.
//

import Foundation

extension Date {

    func adding(months: Int) -> Date? {
        let calendar = Calendar(identifier: .gregorian)

        var components = DateComponents()
        components.calendar = calendar
        components.timeZone = TimeZone(secondsFromGMT: 0)
        components.month = months

        return calendar.date(byAdding: components, to: self)
    }

}
