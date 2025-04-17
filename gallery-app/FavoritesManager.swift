import Foundation

class FavoritesManager {
    static let shared = FavoritesManager()
    
    private let defaults = UserDefaults.standard
    private let favoritesKey = "favoritePhotoIDs"
    private(set) var favoritePhotoIDs: Set<String> = []
    
    private init() {
        loadFavorites()
    }
    
    private func loadFavorites() {
        if let savedIDs = defaults.array(forKey: favoritesKey) as? [String] {
            favoritePhotoIDs = Set(savedIDs)
        }
    }
    
    private func saveFavorites() {
        defaults.set(Array(favoritePhotoIDs), forKey: favoritesKey)
    }
    

    func addFavorite(photoID: String) {
        favoritePhotoIDs.insert(photoID)
        saveFavorites()
    }
    

    func removeFavorite(photoID: String) {
        favoritePhotoIDs.remove(photoID)
        saveFavorites()
    }
    

    func isFavorite(photoID: String) -> Bool {
        return favoritePhotoIDs.contains(photoID)
    }

}

#if DEBUG
extension FavoritesManager {
    func setFavorites(ids: [String]) {
        favoritePhotoIDs = Set(ids)
        saveFavorites()
    }

    func resetFavorites() {
        favoritePhotoIDs.removeAll()
        saveFavorites()
    }
}
#endif

