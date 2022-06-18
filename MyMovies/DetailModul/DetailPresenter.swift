//
//  DetailPresenter.swift
//  MyMovies
//
//  Created by Данила on 17.05.2022.
//

import Foundation
import UIKit
import CoreData

protocol DetailViewProtocol: class {
    func setFilm(film: MyMovie)
}

protocol DetailViewPresenterProtocol: class {
    init(view: DetailViewProtocol,router: RouterProtocol, navigationController: UINavigationController, film: MyMovie,  context: NSManagedObjectContext)
    var film: MyMovie { get set }
    func tapSave()
    func saveFilm(film: MyMovie)
}

class DetailPresenter: DetailViewPresenterProtocol {
    
    weak var view: DetailViewProtocol?
    var router: RouterProtocol?
    var navigationController: UINavigationController?
    var film: MyMovie
    var context: NSManagedObjectContext!
    
    required init(view: DetailViewProtocol, router: RouterProtocol, navigationController: UINavigationController, film: MyMovie,  context: NSManagedObjectContext) {
        self.view = view
        self.router = router
        self.navigationController = navigationController
        self.film = film
        self.view?.setFilm( film: film)
        self.context = context
    }
    
    func tapSave() {
        saveFilm(film: film)
        router?.popToRoot()
    }
    
    func saveFilm(film: MyMovie) {
        
        
        do {
            try context.save()
            print("save context")
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}
