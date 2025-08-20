//
//  FilterOptions.swift
//  VideoGameDatabase
//
//  Created by macbook on 20/8/25.
//

import Foundation

struct FilterOptions: Equatable {
    enum Platform: Int {
        case all = 0, pc, playstation, xbox, nintendoSwitch
        var ids: [Int]? {
            switch self {
            case .all: return nil
            case .pc: return [4]
            case .playstation: return [187, 18]
            case .xbox: return [186, 1]
            case .nintendoSwitch: return [7]
            }
        }
    }
    enum DateRange: Int { case any = 0, thisYear, last90d, upcoming }
    enum Sort: Int { case relevance = 0, newest, rating, metacritic }
    
    var platform: Platform = .all
    var dateRange: DateRange = .any
    var sort: Sort = .relevance
    var metacriticMin: Int = 0
    
    static let `default` = FilterOptions()
}

extension FilterOptions {
    func datesParamString(today: Date = Date()) -> String? {
        let cal = Calendar.current
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd"
        
        switch dateRange {
        case .any:
            return nil
        case .thisYear:
            let start = cal.date(from: cal.dateComponents([.year], from: today)) ?? today
            return "\(fmt.string(from: start)),\(fmt.string(from: today))"
        case .last90d:
            let start = cal.date(byAdding: .day, value: -90, to: today) ?? today
            return "\(fmt.string(from: start)),\(fmt.string(from: today))"
        case .upcoming:
            let end = cal.date(byAdding: .day, value: 120, to: today) ?? today
            return "\(fmt.string(from: today)),\(fmt.string(from: end))"
        }
    }
    
    func platformsParamString() -> String? {
        guard let ids = platform.ids, !ids.isEmpty else { return nil }
        return ids.map(String.init).joined(separator: ",")
    }
    
    func orderingParamString(forSearch: Bool) -> String? {
        switch sort {
        case .relevance:
            return forSearch ? nil : "-added"
        case .newest:     return "-released"
        case .rating:     return "-rating"
        case .metacritic: return "-metacritic"
        }
    }
    
    func metacriticParamString() -> String? {
        metacriticMin > 0 ? "\(metacriticMin),100" : nil
    }
}
