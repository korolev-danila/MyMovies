//
//  MainPresenter.swift
//  ViewedMovies
//
//  Created by Данила on 14.05.2022.
//

import Foundation
import UIKit
import CoreData

protocol MainViewProtocol: class {

    func settingNC()
}

protocol MainPresenterProtocol: class {
    
    init(view: MainViewProtocol, router: RouterProtocol, navigationController: UINavigationController, context: NSManagedObjectContext)
    
    func showSearch()
    func showDetail(film: MyMovie)
    func delete(film: MyMovie)
    
    var context: NSManagedObjectContext { get set }
    var myMyvies: [MyMovie] { get set }
    var router: RouterProtocol? { get set }
    var navigationController: UINavigationController? { get set }
    
}

class MainPresenter: MainPresenterProtocol {
    
    var context: NSManagedObjectContext
    var myMyvies: [MyMovie] = []
    
    weak var view: MainViewProtocol?
    var router: RouterProtocol?
    var navigationController: UINavigationController? 
    
    required init(view: MainViewProtocol, router: RouterProtocol, navigationController: UINavigationController, context: NSManagedObjectContext) {
        self.view = view
        self.router = router
        self.navigationController = navigationController
        self.context = context
    }

    @objc func showSearch() {
        router?.showSearchModul()
        print("presente != nil in presenter")
    }
    
    func showDetail(film: MyMovie) {
        router?.showDetailModul(film: film)
    }
    
    // MARK: - DeleteMovie
    func delete(film: MyMovie) {
        print("delete")
        do {
            try context.delete(film)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}
