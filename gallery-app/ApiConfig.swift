import Foundation

struct ApiConfig {
    static let apiKey: String = {
        guard let key = ProcessInfo.processInfo.environment["UNSPLASH_API_KEY"] else {
            fatalError("UNSPLASH_API_KEY is not found")
        }
        return key
    }()
}
