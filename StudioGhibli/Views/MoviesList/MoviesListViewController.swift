import Foundation
import UIKit

class MoviesListViewController: UIViewController {
    
    // Objeto de tableview que sera usado para mostrar las peliculas
    private let tableView = UITableView()
    // Servicio que sera usado para obtener la informacion, en este caso se usa el protocolo y no la clase
    private let movieService: MoviesServiceProtocol
    // Array that stores information
    private var movies: [Movie] = []

    // Se inyecta el servicio desde afuera permitiendonos usar mock values en el testing
    init(movieService: MoviesServiceProtocol = MovieService()) {
        self.movieService = movieService
        super.init(nibName: nil, bundle: nil)
    }
    // Initializador
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Ghibli Films"
        
        setupTableView() //Configurar el tableview
        fetchMovies() // Llamar al servicio de las peliculas
    }
    
    private func setupTableView() {
        view.addSubview(tableView) // Agregamos la tabla a la vista principal
        tableView.translatesAutoresizingMaskIntoConstraints = false

        tableView.dataSource = self // Esta vista será la fuente de datos
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        // Auto Layout programático para que la tabla ocupe toda la pantalla
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    private func fetchMovies() {
        // llamamos al servicio que se inyecto anteriormente
        movieService.fetchMovies { [weak self] result in
            switch result {
            case .success(let movies):
                // Si fue exitoso, se guardan los datos y se recargan en la tabla
                self?.movies = movies
                self?.tableView.reloadData()
                
            case .failure(let error):
                //si se falla se muestra error en consola
                print("Error fetching movies: \(error.localizedDescription)")
            }
        }
    }
}

extension MoviesListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movie = movies[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        //Configuramos el contenido de las celdas
        var cellInfo = cell.defaultContentConfiguration()
        cellInfo.text = movie.title
        cellInfo.secondaryText = movie.releaseDate
        cell.contentConfiguration = cellInfo
        return cell
    }
    
    //Navigate and select row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMovie = movies[indexPath.row]
        let detailVC = MovieDetailsViewController(movie: selectedMovie)
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

