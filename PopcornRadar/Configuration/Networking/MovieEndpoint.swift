import Foundation
enum TimeWindow: String { case day, week }

enum MovieEndpoint
{
    case popular(page: Int = 1)
    case trending(timeWindow: TimeWindow = .day) // "day" або "week"
    case details(id: Int)
    case search(query: String, page: Int = 1)
    case discovery(genreID: Int, page: Int = 1)
    case genres
    
    var path: String {
            switch self {
            case .popular:
                return "/movie/popular"
            case .trending(let timeWindow):
                return "/trending/movie/\(timeWindow.rawValue)"
            case .details(let id):
                return "/movie/\(id)"
            case .search:
                return "/search/movie"
            case .discovery:
                return "/discover/movie"
            case .genres:
                return "/genre/movie/list"
            }
        }

    var queryItems: [URLQueryItem] {
        switch self {
        case .popular(let page):
            return [URLQueryItem(name: "page", value: "\(page)"),
                    URLQueryItem(name: "language", value: "uk-UA")]
        case .trending:
            return [URLQueryItem(name: "language", value: "uk-UA")]
        case .details:
            return [URLQueryItem(name: "language", value: "uk-UA")]
        case .discovery(genreID: let genreID, page: let page):
            return [
                URLQueryItem(name: "with_genres", value: "\(genreID)"),
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "language", value: "uk-UA")
            ]
        case .search(let query, let page):
            return [
                URLQueryItem(name: "query", value: query),
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "language", value: "uk-UA")
            ]
        case .genres:
                return [URLQueryItem(name: "language", value: "uk-UA")]
           
        }
    }
}
