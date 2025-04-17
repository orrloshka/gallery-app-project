import UIKit
import SDWebImage

class GalleryViewController: UIViewController {

    // MARK: - Properties
    var viewModel = GalleryViewModel()
    private var collectionView: UICollectionView!
    private var showingFavoritesOnly = false

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureCollectionView()
        setupNavigationItems()
        setupBindings()
        viewModel.loadInitialPhotos()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleFavoritesChanged),
                                               name: .favoritesDidChange,
                                               object: nil)

    }

    
    @objc private func handleFavoritesChanged() {
        collectionView.reloadData()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }

    // MARK: - Setup
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        let itemsPerRow: CGFloat = 4
        let itemWidth = floor(view.bounds.width / itemsPerRow)

        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = .zero

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(GalleryCollectionViewCell.self, forCellWithReuseIdentifier: "GalleryCell")

        view.addSubview(collectionView)
    }

    private func setupNavigationItems() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "❤️ Favourites",
            style: .plain,
            target: self,
            action: #selector(toggleFavoritesFilter)
        )
    }

    @objc private func toggleFavoritesFilter() {
        showingFavoritesOnly.toggle()
        let title = showingFavoritesOnly ? "❤️ Favourites" : "📸 All"
        navigationItem.leftBarButtonItem?.title = title
        collectionView.reloadData()
    }

    private func setupBindings() {
        viewModel.onPhotosUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }

        viewModel.onError = { [weak self] error in
            DispatchQueue.main.async {
                self?.showErrorAlert(error: error)
            }
        }
    }

    private func showErrorAlert(error: Error) {
        let alert = UIAlertController(title: "error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default))
        present(alert, animated: true)
    }

    private func filteredPhotos() -> [Photo] {
        return showingFavoritesOnly
            ? viewModel.photos.filter { FavoritesManager.shared.isFavorite(photoID: $0.id) }
            : viewModel.photos
    }
}

// MARK: - UICollectionViewDataSource
extension GalleryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredPhotos().count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryCell", for: indexPath) as? GalleryCollectionViewCell else {
            fatalError("Не удалось инициализировать GalleryCollectionViewCell")
        }

        let photo = filteredPhotos()[indexPath.item]

        if let url = URL(string: photo.urls.small ?? "") {
            cell.imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
        }

        let isFavorite = FavoritesManager.shared.isFavorite(photoID: photo.id)
        cell.configureFavorite(isFavorite: isFavorite)

        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension GalleryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedPhoto = filteredPhotos()[indexPath.item]
        let detailVC = DetailViewController(photo: selectedPhoto, allPhotos: filteredPhotos())
        navigationController?.pushViewController(detailVC, animated: true)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !showingFavoritesOnly else { return }

        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let visibleHeight = scrollView.frame.height

        if offsetY > contentHeight - visibleHeight * 1.5 {
            viewModel.loadMorePhotos()
        }
    }
    
}

extension Notification.Name {
    static let favoritesDidChange = Notification.Name("favoritesDidChange")
}
