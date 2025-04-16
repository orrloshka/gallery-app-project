import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {

    let imageView = UIImageView()
    private let heartImageView = UIImageView()
    private let descriptionLabel = UILabel() 

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImageView()
        setupHeartImageView()
        setupDescriptionLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor) // квадрат
        ])
    }

    private func setupHeartImageView() {
        heartImageView.translatesAutoresizingMaskIntoConstraints = false
        heartImageView.contentMode = .scaleAspectFit
        heartImageView.tintColor = .systemRed
        contentView.addSubview(heartImageView)

        NSLayoutConstraint.activate([
            heartImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            heartImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            heartImageView.widthAnchor.constraint(equalToConstant: 20),
            heartImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    private func setupDescriptionLabel() {
        descriptionLabel.font = UIFont.systemFont(ofSize: 10)
        descriptionLabel.textColor = .darkGray
        descriptionLabel.numberOfLines = 2
        descriptionLabel.textAlignment = .center
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(descriptionLabel)

        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 2),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 2),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -2),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2)
        ])
    }

    func configureFavorite(isFavorite: Bool) {
        if isFavorite {
            heartImageView.alpha = 0
            heartImageView.image = UIImage(systemName: "heart.fill")
            UIView.animate(withDuration: 0.3) {
                self.heartImageView.alpha = 1
            }
        } else {
            heartImageView.image = nil
        }
    }

    func setDescription(_ text: String?) {
        descriptionLabel.text = text ?? ""
    }
}
