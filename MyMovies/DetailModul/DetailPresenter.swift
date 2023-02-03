//
//  DetailPresenter.swift
//  MyMovies
//
//  Created by Данила on 17.05.2022.
//

import CoreData

protocol DetailPresenterProtocol: AnyObject {
    func getMovie()
    func tapSave(watched: Bool, comment: String, rating: Double)
}

struct ViewModel {
    var watched: Bool
    var name: String
    var year: String
    var rating: Double
    var comment: String
    var imageData: Data?
}

final class DetailPresenter {
    weak var view: DetailViewProtocol?
    private let router: RouterProtocol
    private let context: NSManagedObjectContext
    
    private var movie: MyMovie
    
    // MARK: - Initialize Method
    init(router: RouterProtocol, context: NSManagedObjectContext, movie: MyMovie) {
        self.router = router
        self.context = context
        self.movie = movie
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - DetailPresenterProtocol
extension DetailPresenter: DetailPresenterProtocol {
    func getMovie() {
        var model = ViewModel(watched: movie.watched, name: movie.name ?? "",
                              year: movie.year ?? "", rating: movie.rating,
                              comment: movie.comment ?? "")
        model.year += " year"
        view?.setMovie(model)
    }
    
    func tapSave(watched: Bool, comment: String, rating: Double) {
        movie.watched = watched
        movie.comment = comment
        movie.rating = rating
        
        do {
            try context.save()
            print("save context")
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        router.popToRoot()
    }
}
