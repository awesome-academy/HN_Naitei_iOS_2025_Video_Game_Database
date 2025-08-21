//
//  Date+Format.swift
//  VideoGameDatabase
//
//  Created by macbook on 21/8/25.
//
import Foundation

extension Date {
    private static let ymdFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()
    
    func ymdString() -> String {
        Date.ymdFormatter.string(from: self)
    }
    
    func startOfYear(using calendar: Calendar = .current) -> Date {
        calendar.date(from: calendar.dateComponents([.year], from: self)) ?? self
    }
    
    func addingDays(_ days: Int, using calendar: Calendar = .current) -> Date {
        calendar.date(byAdding: .day, value: days, to: self) ?? self
    }
}

