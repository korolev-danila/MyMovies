//
//  SearchPresenter.swift
//  ViewedMovies
//
//  Created by Данила on 14.05.2022.
//

import Foundation
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
}

final class SearchPresenter {
    weak var view: SearchViewProtocol?
    private let router: RouterProtocol
    private let context: NSManagedObjectContext
    
    var films = [Film]()
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
                self?.movies = searchMovies.Search
//                self?.films.removeAll()
//
//                self?.movies.forEach({ movie in
//                    var film = Film()
//                    film.name = movie.Title
//                    film.year = movie.Year
//                    film.imdbID = movie.imdbID
//                    film.imageStr = movie.Poster
//
//                    self?.films.append(film)
//                })
                self?.view?.reloadTable()
            } else {
                self?.view?.alertOk(title: "Error", message: "Film not found")
            }
        }
    }
    
    func showDetail(index: IndexPath) {
        guard let entity = NSEntityDescription.entity(forEntityName: "MyMovie", in: context) else { return }
        
        let filmObject = MyMovie(entity: entity, insertInto: context)
//        filmObject.name = films[index].name
//        filmObject.year = films[index].year
//        filmObject.imdbID = films[index].imdbID
//        filmObject.rating = Int16(films[index].rating)
//        filmObject.imageData = films[index].imageData
//        filmObject.watched = films[index].watched
//        filmObject.comment = films[index].comment
        
        router.showDetailModul(film: filmObject)
    }
    
    func getCountOfMovie() -> Int {
        return movies.count
    }
    
    func getTableModel(index: IndexPath) -> TableCellModel {
        
        var movie = movies[safe: index.row]
        var model = TableCellModel(name: movie?.Title ?? "", year: "")
        
        if let year = movie?.Year {
            model.year = "\(year) year"
        }
        
        if let urlString = movie?.Poster {
            NetworkRequest.shared.requestDataPoster(urlString: urlString) { [weak self] result in
                switch result {
                case .success(let data):
//                    self?.presenter.films[indexPath.row].imageData = data
//                    cell.setImage(imageData: data)
                    print("No")
                case .failure(let error):
//                    let filmLogo = UIImage(named: "filmLogo")?.pngData()
//                    self?.presenter.films[indexPath.row].imageData = filmLogo
//                    cell.setImage(imageData: filmLogo!)
                    print("No film logo" + error.localizedDescription)
                }
            }
        }
        return model 
    }
}

