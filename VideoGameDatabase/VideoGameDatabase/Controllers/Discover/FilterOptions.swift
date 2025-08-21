import Foundation

struct FilterOptions: Equatable {
    enum Platform: Int {
        case all = 0
        case pc
        case playstation
        case xbox
        case nintendoSwitch
        
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
    
    enum DateRange: Int {
        case any = 0
        case thisYear
        case last90d
        case upcoming
    }
    
    enum Sort: Int {
        case relevance = 0
        case newest
        case rating
        case metacritic
    }
    
    var platform: Platform = .all
    var dateRange: DateRange = .any
    var sort: Sort = .relevance
    var metacriticMin: Int = 0
    
    static let `default` = FilterOptions()
}

extension FilterOptions {
    func datesParamString(today: Date = Date()) -> String? {
        switch dateRange {
        case .any:
            return nil
        case .thisYear:
            let start = today.startOfYear()
            return "\(start.ymdString()),\(today.ymdString())"
        case .last90d:
            let start = today.addingDays(-90)
            return "\(start.ymdString()),\(today.ymdString())"
        case .upcoming:
            let end = today.addingDays(120)
            return "\(today.ymdString()),\(end.ymdString())"
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
        case .newest:
            return "-released"
        case .rating:
            return "-rating"
        case .metacritic:
            return "-metacritic"
        }
    }
    
    func metacriticParamString() -> String? {
        metacriticMin > 0 ? "\(metacriticMin),100" : nil
    }
}
