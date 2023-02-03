//
//  SearchPresenter.swift
//  ViewedMovies
//
//  Created by Данила on 14.05.2022.
//

import CoreData

protocol SearchPresenterProtocol: AnyObject {
    func searchFilm(_ filmName: String)
    func showDetail(index: IndexPath)
    func getCountOfMovie() -> Int
    func getTableModel(index: IndexPath) -> TableCellModel
}

struct TableCellModel {
    var name: String
    var year: String
    var image: Data?
}

final class SearchPresenter {
    weak var view: SearchViewProtocol?
    private let router: RouterProtocol
    private let context: NSManagedObjectContext
    
    var movies = [Movie]()
    
    // MARK: - Initialize Method
    init(router: RouterProtocol, context: NSManagedObjectContext) {
        self.router = router
        self.context = context
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SearchPresenterProtocol
extension SearchPresenter: SearchPresenterProtocol {
    func searchFilm(_ name: String) {
        NetworkDataFetch.shared.fetchMovie(searchName: name) { [weak self] moviesModel, error in
            print("11")
            guard let searchMovies = moviesModel else { return }
            
            if error == nil {
                self?.movies = searchMovies.search
                self?.view?.reloadTable()
            } else {
                self?.view?.alertOk(title: "Error", message: "Film not found")
            }
        }
    }
    
    func showDetail(index: IndexPath) {
        guard let entity = NSEntityDescription.entity(forEntityName: "MyMovie", in: context),
              let movie = movies[safe: index.row] else { return }
        
        let filmObject = MyMovie(entity: entity, insertInto: context)
        
        filmObject.name = movie.title
        filmObject.year = movie.year
        filmObject.imdbID = movie.imdbID
        filmObject.imageData = movie.imageData
        
        router.showDetailModul(movie: filmObject)
    }
    
    func getCountOfMovie() -> Int {
        return movies.count
    }
    
    func getTableModel(index: IndexPath) -> TableCellModel {
        let movie = movies[safe: index.row]
        var model = TableCellModel(name: movie?.title ?? "", year: "")
        
        if let year = movie?.year {
            model.year = "\(year) year"
        }
        
        if movie?.imageData == nil {
            if let urlString = movie?.poster {
                NetworkRequest.shared.requestDataPoster(urlString: urlString) { [weak self] result in
                    switch result {
                    case .success(let data):
                        if self?.movies[safe: index.row] != nil {
                            self?.movies[index.row].imageData = data
                            self?.view?.reloadCell(index)
                        }
                    case .failure(let error):
                        print("No film logo" + error.localizedDescription)
                    }
                }
            }
        } else {
            model.image = movie?.imageData
        }
        return model
    }
}

