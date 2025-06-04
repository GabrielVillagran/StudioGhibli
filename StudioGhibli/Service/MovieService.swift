import Foundation

class MovieService: MoviesServiceProtocol {
    // URL de donde se obtendra la informacion
    private let urlFetch = "https://ghibliapi.vercel.app/films"
    
    func fetchMovies(completion: @escaping (Result<[Movie], any Error>) -> Void) {
        // Convertir el string d objeto URL
        guard let url = URL(string: urlFetch) else { return }
        
        // Se crea una tarea o con URLSession para poder hacer el request de HTTP
        URLSession.shared.dataTask(with: url) { data, response, error in
            // Si hay error de red se envia al completion handler com un fallo
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            // Se valida que haya datos recibido
            guard let data = data else {
                DispatchQueue.main.async {
                    // Si np hay datos se maneja el error con uno creado manualmente
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data returned"])))
                }
                return
            }
            do {
                // Se intenta decodificar el JSON a un tipo array de nuestro modelo llamado Movie
                let movies = try JSONDecoder().decode([Movie].self, from: data)
                
                DispatchQueue.main.async {
                    completion(.success(movies)) // Si se decodifico, este arreglo se envia
                }
            } catch {
                // Si no se puede modificar se envia el error
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        } .resume() // Permite ejecutar la tarea
    }

}
// A cpmletion handler is a function that will be executed once the asynchronous task has finished like fetching information, store information on the device or query a data base, here is used because we are using URLSession wnich is asynchronous, we don't know the exact time that will take to return the result
