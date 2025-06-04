import Foundation

protocol MoviesServiceProtocol {
    func fetchMovies(completion: @escaping (Result<[Movie], Error>) -> Void)
}

///MARK: A protocol is like a contract, bassycally protocols assign one function that must be implemented by the class that make use of the protocol, the use of protocols llow us to change the implementation for using a mock service and make our code testable as well as separate responsabilities.
