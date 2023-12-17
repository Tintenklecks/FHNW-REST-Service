import Foundation

// MARK: - HTTPMethod

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

// MARK: - NetworkError

public enum NetworkError: Error, Equatable {
    case badURL
    case apiError(code: Int)
    case invalidJSON
    case serverError(code: Int)
    case unableToParseData
    case thrownError(error: String)

    // MARK: Public

    public var description: String {
        switch self {
        case .badURL: return "ERROR: Invalid url!"
        case .apiError(let code): return "ERROR: API failed with code \(code)"
        case .invalidJSON: return "ERROR: Invalid json file!"
        case .serverError(let code): return "ERROR: Server failed with code:\(code)"
        case .unableToParseData: return "ERROR: Unable to parse data!"
        case .thrownError(let error): return "ERROR: \(error)"
        }
    }
}

// MARK: - DataService

protocol RestServiceProtocol {
    var defaultHeader: [String: String] { get }
    init(defaultHeader: [String: String])
    func request<T: Codable>(
        method: HTTPMethod,
        url: String,
        convertTo type: T.Type,
        headers: [String: String]?,
        urlParameter: [String: String]?,
        queryParameter: [String: String]?,
        body: Codable?) async throws -> T

    func get<T: Codable>(
        url: String,
        convertTo type: T.Type,
        urlParameter: [String: String]?,
        queryParameter: [String: String]?) async throws -> T
}

// MARK: - RestService

class RestService: RestServiceProtocol {
    var defaultHeader: [String : String]
    

    required init(defaultHeader: [String: String] = [:]) {
        self.defaultHeader = defaultHeader
    }

    func request<T: Codable>(
        method: HTTPMethod,
        url: String,
        convertTo type: T.Type,
        headers: [String: String]? = nil,
        urlParameter: [String: String]? = nil,
        queryParameter: [String: String]? = nil,
        body: Codable? = nil) async throws -> T
    {
        var urlString = url

        // Replace URL Path Parameters
        urlParameter?.forEach { key, value in
            urlString = urlString.replacingOccurrences(of: ":\(key)", with: value)
        }

        guard var requestURL = URL(string: urlString) else {
            throw NetworkError.badURL
        }

        // Append URL Query Parameters
        if let urlQueryParams = queryParameter {
            var urlComponents = URLComponents(url: requestURL, resolvingAgainstBaseURL: false)
            urlComponents?.queryItems = urlQueryParams.map { URLQueryItem(name: $0.key, value: $0.value) }
            requestURL = urlComponents?.url ?? requestURL
        }

        var request = URLRequest(url: requestURL)
        request.httpMethod = method.rawValue

        // Set Default Header
        for (key, value) in defaultHeader {
            request.setValue(value, forHTTPHeaderField: key)
        }

        // short form:
        // defaultHeader.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }

        // Set Headers
        headers?.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }

        // Set JSON Body
        if let body {
            let jsonData = try JSONEncoder().encode(body)
            request.httpBody = jsonData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        let (data, response) = try await URLSession.shared.data(for: request)
        if let statusCode = (response as? HTTPURLResponse)?.statusCode,
           statusCode >= 300
        {
            throw NetworkError.serverError(code: statusCode)
        }

        // Decode the data stream to an instance of the datatype T
        let instanceOfTType = try JSONDecoder().decode(type.self, from: data)
        return instanceOfTType
    }

    func get<T: Codable>(
        url: String,
        convertTo type: T.Type,
        urlParameter: [String: String]? = nil,
        queryParameter: [String: String]? = nil) async throws -> T
    {
        try await request(method: .get,
                          url: url, convertTo: T.self,
                          urlParameter: urlParameter,
                          queryParameter: queryParameter)
    }
}
