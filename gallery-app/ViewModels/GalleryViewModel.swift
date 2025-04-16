import Foundation

class GalleryViewModel {
    // MARK: - Properties
    var photos: [Photo] = []
    private var currentPage: Int = 1
    private let perPage: Int = 30
    private(set) var isLoading: Bool = false
    
    private let unsplashService: UnsplashService
    private let favoritesManager = FavoritesManager.shared
    
    var onPhotosUpdated: (() -> Void)?
    var onError: ((Error) -> Void)?
    
    // MARK: - Initialization
    init(service: UnsplashService = UnsplashService()) {
        self.unsplashService = service
    }
    
    // MARK: - Public Methods
    
    func loadInitialPhotos() {
        guard !isLoading else { return }
        isLoading = true

        unsplashService.fetchPhotos(page: currentPage, perPage: 30) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let newPhotos):
                    self?.photos = newPhotos
                    self?.onPhotosUpdated?()
                case .failure(let error):
                    self?.onError?(error)
                }
            }
        }
    }

    
    func loadMorePhotos() {
        guard !isLoading else { return }
        isLoading = true
        currentPage += 1
        
        unsplashService.fetchPhotos(page: currentPage, perPage: perPage) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                switch result {
                case .success(let fetchedPhotos):
                    self.photos.append(contentsOf: fetchedPhotos)
                    self.onPhotosUpdated?()
                case .failure(let error):
                    self.onError?(error)
                }
            }
        }
    }
    
    func isFavorite(photo: Photo) -> Bool {
        return favoritesManager.isFavorite(photoID: photo.id)
    }
    

    func toggleFavorite(photo: Photo) {
        if isFavorite(photo: photo) {
            favoritesManager.removeFavorite(photoID: photo.id)
        } else {
            favoritesManager.addFavorite(photoID: photo.id)
        }
        onPhotosUpdated?()
    }
    
    func reset() {
        photos = []
        currentPage = 1
        isLoading = false
    }

}
