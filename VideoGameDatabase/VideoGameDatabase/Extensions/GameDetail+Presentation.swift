import Foundation

extension GameDetail {
    var platformsText: String {
        guard let platformItems = platforms else { return "-" }
        let platformNames: [String] = platformItems.compactMap { platformItem in
            if let name = platformItem.platform?.name, !name.isEmpty { return name }
            if let name = platformItem.name, !name.isEmpty { return name }
            return nil
        }
        return platformNames.isEmpty ? "-" : platformNames.joined(separator: ", ")
    }

    var genresText: String {
        guard let genres = genres else { return "-" }
        let names = genres.map { $0.name }
        return names.isEmpty ? "-" : names.joined(separator: ", ")
    }

    var developersText: String {
        guard let developers = developers else { return "-" }
        let names = developers.map { $0.name }
        return names.isEmpty ? "-" : names.joined(separator: ", ")
    }

    var publishersText: String {
        guard let publishers = publishers else { return "-" }
        let names = publishers.map { $0.name }
        return names.isEmpty ? "-" : names.joined(separator: ", ")
    }

    var tagsText: String {
        guard let tags = tags else { return "-" }
        let names = tags.map { $0.name }
        return names.isEmpty ? "-" : names.joined(separator: ", ")
    }

    var ageRatingText: String {
        esrbRating?.name ?? "Not rated"
    }

    var releaseDateFormatted: String {
        guard let releasedString = released, !releasedString.isEmpty else { return "-" }

        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"

        if let date = inputFormatter.date(from: releasedString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateStyle = .medium
            return outputFormatter.string(from: date)
        }
        return releasedString
    }
}
