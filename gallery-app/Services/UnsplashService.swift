import Foundation

enum ServiceError: Error {
    case invalidURL
    case noData
}

class UnsplashService {
    private let baseURL = "https://api.unsplash.com"
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetchPhotos(page: Int, perPage: Int, completion: @escaping (Result<[Photo], Error>) -> Void) {
        guard var urlComponents = URLComponents(string: "\(baseURL)/photos") else {
            completion(.failure(ServiceError.invalidURL))
            return
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "\(perPage)")
        ]
        
        guard let url = urlComponents.url else {
            completion(.failure(ServiceError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("Client-ID \(ApiConfig.apiKey)", forHTTPHeaderField: "Authorization")
        
        let dataTask = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(ServiceError.noData))
                return
            }
            
            do {
                let photos = try JSONDecoder().decode([Photo].self, from: data)
                completion(.success(photos))
            } catch {
                completion(.failure(error))
            }
        }
        
        dataTask.resume()
    }
}
