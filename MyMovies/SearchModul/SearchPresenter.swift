//
//  SearchPresenter.swift
//  ViewedMovies
//
//  Created by Данила on 14.05.2022.
//

import Foundation
import UIKit
import CoreData

protocol SearchViewProtocol: class {
    func alertOk(title: String, message: String)
    var myTableView: UITableView { get set }
}

protocol SearchPresenterProtocol: class {
    init(view: SearchViewProtocol, router: RouterProtocol, navigationController: UINavigationController, context: NSManagedObjectContext)
    
    var films: [Film] { get set }
    var timer: Timer { get set }
    var movies: [Movie] { get set }
    func searchFilm(filmName: String)
    func showDetail(index: Int) 
}

class SearchPresenter: SearchPresenterProtocol {
    
    var films = [Film]()
    var movies = [Movie]()
    var timer = Timer()
    weak var view: SearchViewProtocol?
    var router: RouterProtocol?
    var navigationController: UINavigationController?
    var context: NSManagedObjectContext!
    
    required init(view: SearchViewProtocol, router: RouterProtocol, navigationController: UINavigationController, context: NSManagedObjectContext) {
        self.view = view
        self.router = router
        self.navigationController = navigationController
        self.context = context
    }
    
    func searchFilm(filmName: String) {
        
        NetworkDataFetch.shared.fetchMovie(searchName: filmName) { [weak self] movieModel, error in
            
            if error == nil {
                self?.movies = movieModel!.Search
                self?.films.removeAll()
                
                self?.movies.forEach({ movie in
                    var film = Film()
                    film.name = movie.Title
                    film.year = movie.Year
                    film.imdbID = movie.imdbID
                    film.imageStr = movie.Poster
                    
                    self?.films.append(film)
                })
                self?.view?.myTableView.reloadData()
            } else {
                self?.view?.alertOk(title: "Error", message: "Film not found")
            }
        }
    }
    
    func showDetail(index: Int) {
        
        guard let entity = NSEntityDescription.entity(forEntityName: "MyMovie", in: context) else { return }
        
        let filmObject = MyMovie(entity: entity, insertInto: context)
        filmObject.name = films[index].name
        filmObject.year = films[index].year
        filmObject.imdbID = films[index].imdbID
        filmObject.rating = Int16(films[index].rating)
        filmObject.imageData = films[index].imageData
        filmObject.watched = films[index].watched
        filmObject.comment = films[index].comment
        
        router?.showDetailModul(film: filmObject)
    }
}

