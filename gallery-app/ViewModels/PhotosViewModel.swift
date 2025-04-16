import Foundation

class PhotosViewModel {
    private let unsplashService = UnsplashService()
    var photos: [Photo] = []

    func loadPhotos(page: Int = 1, perPage: Int = 30, completion: @escaping () -> Void) {
        unsplashService.fetchPhotos(page: page, perPage: perPage) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let photos):
                    self?.photos = photos
                    print("Photos received: \(photos.count)")
                case .failure(let error):
                    print("Error: \(error)")
                }
                completion()
            }
        }
    }
}
