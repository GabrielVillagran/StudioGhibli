import Foundation
import UIKit
import SwiftUI

class MovieDetailsViewController: UIViewController {
    
    private let movie: Movie
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let originalTitleLabel = UILabel()
    private let releaseDateLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let swiftUIButton = UIButton(type: .system)

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
        title = movie.title
        
        addElements()
        setupUI()
        showInformation()
    }

    private func addElements() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        view.addSubview(titleLabel)

        originalTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        originalTitleLabel.font = .systemFont(ofSize: 17, weight: .regular)
        view.addSubview(originalTitleLabel)

        releaseDateLabel.translatesAutoresizingMaskIntoConstraints = false
        releaseDateLabel.font = .systemFont(ofSize: 17, weight: .regular)
        view.addSubview(releaseDateLabel)

        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.numberOfLines = 0
        view.addSubview(descriptionLabel)

        // Configuración del botón que navegará a SwiftUI
        swiftUIButton.translatesAutoresizingMaskIntoConstraints = false
        swiftUIButton.setTitle("Ir a Vista SwiftUI", for: .normal)
        swiftUIButton.addTarget(self, action: #selector(navigateToSwiftUI), for: .touchUpInside)
        view.addSubview(swiftUIButton)
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
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            swiftUIButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 30),
            swiftUIButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func showInformation() {
        titleLabel.text = movie.title
        originalTitleLabel.text = "Original Title: \(movie.originalTitleRomanised)"
        releaseDateLabel.text = "Release Date: \(movie.releaseDate)"
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

    @objc private func navigateToSwiftUI() {
        // Aquí se navega a una vista SwiftUI dentro del stack de navegación UIKit
        let swiftUIView = SwiftUIView()
        let hostingController = UIHostingController(rootView: swiftUIView)
        navigationController?.pushViewController(hostingController, animated: true)
    }
}
