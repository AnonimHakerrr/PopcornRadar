import Foundation

enum MovieEndpoint
{
    case popular(page: Int = 1)
    case trending(timeWindow: String = "day") // "day" або "week"
    case details(id: Int)
    case search(query: String, page: Int = 1)
    
    var path: String {
            switch self {
            case .popular:
                return "/movie/popular"
            case .trending:
                return "/trending/movie"
            case .details(let id):
                return "/movie/\(id)"
            case .search:
                return "/search/movie"
            }
        }

    var queryItems: [URLQueryItem] {
        switch self {
        case .popular(let page):
            return [URLQueryItem(name: "page", value: "\(page)")]
        case .trending(let timeWindow):
            return [URLQueryItem(name: "time_window", value: timeWindow)]
        case .details:
            return []
        case .search(let query, let page):
            return [
                URLQueryItem(name: "query", value: query),
                URLQueryItem(name: "page", value: "\(page)")
            ]
        }
    }
}
