import UIKit
import SDWebImage

class DetailViewController: UIViewController {

    private var photo: Photo
    private var allPhotos: [Photo]
    private var currentIndex: Int

    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    init(photo: Photo, allPhotos: [Photo]) {
        self.photo = photo
        self.allPhotos = allPhotos
        self.currentIndex = allPhotos.firstIndex { $0.id == photo.id } ?? 0
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupScrollView()
        setupImageView()
        setupLabels()
        setupFavoriteButton()
        loadPhoto()
        setupSwipeGestures()
    }

    private func setupSwipeGestures() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
    }

    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }

    private func setupImageView() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1.3)
        ])
    }

    private func setupLabels() {
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.textColor = .lightGray
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -30)
        ])
    }

    private func setupFavoriteButton() {
        let isFav = FavoritesManager.shared.isFavorite(photoID: photo.id)
        let heartImage = UIImage(systemName: isFav ? "heart.fill" : "heart")
        let heartButton = UIBarButtonItem(image: heartImage, style: .plain, target: self, action: #selector(favoriteTapped))
        heartButton.tintColor = isFav ? .systemRed : .white
        navigationItem.rightBarButtonItem = heartButton
    }

    @objc private func favoriteTapped() {
        if allPhotos.count == 1 && FavoritesManager.shared.isFavorite(photoID: photo.id) {
            FavoritesManager.shared.removeFavorite(photoID: photo.id)
            navigationController?.popViewController(animated: true)
            return
        }

        if FavoritesManager.shared.isFavorite(photoID: photo.id) {
            FavoritesManager.shared.removeFavorite(photoID: photo.id)
        } else {
            FavoritesManager.shared.addFavorite(photoID: photo.id)
            animateFavorite()
        }
        setupFavoriteButton()
    }

    private func animateFavorite() {
        guard let buttonView = navigationItem.rightBarButtonItem?.value(forKey: "view") as? UIView else { return }

        UIView.animate(withDuration: 0.15,
                       animations: {
                           buttonView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                       },
                       completion: { _ in
                           UIView.animate(withDuration: 0.15) {
                               buttonView.transform = CGAffineTransform.identity
                           }
                       })
    }

    @objc private func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        let maxIndex = allPhotos.count - 1

        if gesture.direction == .left {
            if currentIndex < maxIndex {
                currentIndex += 1
            } else {
                return
            }
        } else if gesture.direction == .right {
            if currentIndex > 0 {
                currentIndex -= 1
            } else {
                return
            }
        }

        guard currentIndex >= 0, currentIndex < allPhotos.count else { return }

        photo = allPhotos[currentIndex]
        loadPhoto()
        setupFavoriteButton()
    }

    private func loadPhoto() {
        if let url = URL(string: photo.urls.regular ?? "") {
            imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
        }

        titleLabel.text = photo.altDescription ?? "No title"
        descriptionLabel.text = photo.description ?? "No description"
    }
}
