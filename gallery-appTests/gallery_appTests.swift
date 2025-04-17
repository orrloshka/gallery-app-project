import XCTest
@testable import gallery_app

final class GalleryViewModelTests: XCTestCase {

    override func setUp() {
        super.setUp()
        FavoritesManager.shared.resetFavorites() // Тестовая очистка
    }

    func testToggleFavoriteMarksPhoto() {
        // Создаём тестовый фото-объект
        let urls = URLs(
            raw: "https://example.com/small.jpg",
            full: "https://example.com/regular.jpg",
            regular: "https://example.com/full.jpg",
            small: "https://example.com/raw.jpg",
            thumb: "https://example.com/thumb.jpg"
        )

        let photo = Photo(
            id: "test123",
            altDescription: "Test Alt",
            description: "Test Description",
            urls: urls
        )

        let viewModel = GalleryViewModel()
        viewModel.photos = [photo]

        XCTAssertFalse(viewModel.isFavorite(photo: photo))

        viewModel.toggleFavorite(photo: photo)
        XCTAssertTrue(viewModel.isFavorite(photo: photo))

        viewModel.toggleFavorite(photo: photo)
        XCTAssertFalse(viewModel.isFavorite(photo: photo))
    }
}
