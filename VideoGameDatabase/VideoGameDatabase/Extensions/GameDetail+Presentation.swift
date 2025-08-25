import Foundation

extension GameDetail {
    
    var platformsText: String {
        guard let items = platforms else { return "-" }
        let names = items.compactMap { item -> String? in
            if let n = item.platform?.name, !n.isEmpty { return n }
            if let n = item.name, !n.isEmpty { return n }
            return nil
        }
        return names.isEmpty ? "-" : names.joined(separator: ", ")
    }
    
    var genresText: String {
        genres?.map(\.name).joined(separator: ", ") ?? "-"
    }
    
    var developersText: String {
        developers?.map(\.name).joined(separator: ", ") ?? "-"
    }
    
    var publishersText: String {
        publishers?.map(\.name).joined(separator: ", ") ?? "-"
    }
    
    var tagsText: String {
        tags?.map(\.name).joined(separator: ", ") ?? "-"
    }
    
    var ageRatingText: String {
        esrbRating?.name ?? "Not rated"
    }
    
    var releaseDateFormatted: String {
        guard let s = released else { return "-" }
        let inFmt = DateFormatter()
        inFmt.dateFormat = "yyyy-MM-dd"
        if let d = inFmt.date(from: s) {
            let outFmt = DateFormatter()
            outFmt.dateStyle = .medium
            return outFmt.string(from: d)
        }
        return s
    }
}
