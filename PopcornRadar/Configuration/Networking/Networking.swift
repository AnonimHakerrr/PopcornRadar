import Foundation

enum NetworkError: Error {
    case badURL, badResponse(Int), decodingError(Error), unknown(Error)
}

final class Networking {
    static let shared = Networking()
    
    private init() {}
    
    private let baseURL = "https://api.themoviedb.org/3"
    private let apiKey: String? = Bundle.main.object(forInfoDictionaryKey: "TMDB_API_KEY")as? String
    private var jsonDecoder: JSONDecoder {
        let d = JSONDecoder()
        d.keyDecodingStrategy = .convertFromSnakeCase
        return d
    }
    
    func request<T: Decodable>(endpoint: String,
                               queryItems: [URLQueryItem] = [],
                               httpMethod: String = "GET",
                               headers: [String: String] = [:] ) async throws -> T {
        
        guard var components = URLComponents(string: baseURL + endpoint) else {
            throw URLError(.badURL)
        }
        
        components.queryItems = (components.queryItems ?? []) + queryItems
        
        if let key = apiKey,
           !(components.queryItems?.contains(where: { $0.name == "api_key" }) ?? false) {
            components.queryItems = (components.queryItems ?? []) + [URLQueryItem(name: "api_key", value: key)]
        }
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.timeoutInterval = 15
        print("request \(request)")
        headers.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let http = response as? HTTPURLResponse else {
                throw NetworkError.unknown(URLError(.badServerResponse))
            }
            
            guard 200..<300 ~= http.statusCode else {
                throw NetworkError.badResponse(http.statusCode)
            }
        
            do {
                return try jsonDecoder.decode(T.self, from: data)
            } catch {
                throw NetworkError.decodingError(error)
            }
            
        } catch {
            throw NetworkError.unknown(error)
        }
    }
    
}
