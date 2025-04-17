import XCTest
@testable import gallery_app

final class FavoritesManagerTests: XCTestCase {

    override func setUp() {
        super.setUp()
        FavoritesManager.shared.favoritePhotoIDs = []
    }

    func testAddingFavoritePhoto() {
        let testID = "123"
        FavoritesManager.shared.addFavorite(photoID: testID)

        XCTAssertTrue(FavoritesManager.shared.isFavorite(photoID: testID), "Фото должно быть в избранном")
    }

    func testRemovingFavoritePhoto() {
        let testID = "456"
        FavoritesManager.shared.addFavorite(photoID: testID)
        FavoritesManager.shared.removeFavorite(photoID: testID)

        XCTAssertFalse(FavoritesManager.shared.isFavorite(photoID: testID), "Фото не должно быть в избранном")
    }

    func testIsFavoriteEmptyInitially() {
        XCTAssertFalse(FavoritesManager.shared.isFavorite(photoID: "non-existent"), "Избранное должно быть пустым")
    }
}
