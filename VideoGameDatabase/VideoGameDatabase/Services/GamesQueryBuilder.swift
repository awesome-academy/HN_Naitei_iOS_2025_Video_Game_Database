//
//  GamesQueryBuilder.swift
//  VideoGameDatabase
//
//  Created by macbook on 20/8/25.
//
import Foundation

struct GamesQueryBuilder {
    private var parts: [String] = []
    private let filters: FilterOptions
    init(filters: FilterOptions) { self.filters = filters }
    
    func pageSize(_ n: Int) -> Self { var s=self; s.parts.append("page_size=\(n)"); return s }
    func search(_ q: String) -> Self { var s=self
        s.parts.append("search=\(q.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? q)")
        return s
    }
    func searchExact(_ exact: Bool) -> Self { var s=self; if exact { s.parts.append("search_exact=true") }; return s }
    func genres(_ slugs: Set<String>) -> Self { var s=self; if !slugs.isEmpty { s.parts.append("genres=\(slugs.joined(separator: ","))") }; return s }
    func orderingIfNeeded(forSearch: Bool) -> Self { var s=self
        if let ord = filters.orderingParamString(forSearch: forSearch) { s.parts.append("ordering=\(ord)") }
        return s
    }
    func build() -> String {
        var s = self
        if let p = filters.platformsParamString() { s.parts.append("platforms=\(p)") }
        if let d = filters.datesParamString() { s.parts.append("dates=\(d)") }
        if let m = filters.metacriticParamString() { s.parts.append("metacritic=\(m)") }
        return "/games?\(s.parts.joined(separator: "&"))"
    }
}

