import Foundation
import UIKit

class MovieDetailsViewController: UIViewController {
    
    private let movie: Movie
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let originalTitleLabel = UILabel()
    private let releaseDateLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    init(movie: Movie) {
        self.movie = movie
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        titleLabel.text = movie.title
        
        addElements()
        setupUI()
        showInformation()
    }
    
    private func addElements() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)

        originalTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(originalTitleLabel)
        originalTitleLabel.font = .systemFont(ofSize: 17, weight: .regular)

        releaseDateLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(releaseDateLabel)
        releaseDateLabel.font = .systemFont(ofSize: 17, weight: .regular)

        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        descriptionLabel.numberOfLines = 0

    }
    private func setupUI() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 220),
            imageView.widthAnchor.constraint(equalToConstant: 160),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            originalTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            originalTitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            originalTitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            releaseDateLabel.topAnchor.constraint(equalTo: originalTitleLabel.bottomAnchor, constant: 10),
            releaseDateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            releaseDateLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            descriptionLabel.topAnchor.constraint(equalTo: releaseDateLabel.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)
        ])
    }
    
    private func showInformation() {
        titleLabel.text = movie.title
        originalTitleLabel.text = "Original Title: \(movie.originalTitleRomanised ?? "-")"
        releaseDateLabel.text = "Release Date: \(movie.releaseDate ?? "-")"
        descriptionLabel.text = movie.description

        if let url = URL(string: movie.image) {
            downloadImage(from: url)
        }
    }
    
    private func downloadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
        }.resume()
    }
}
