//
//  MainPresenter.swift
//  ViewedMovies
//
//  Created by Данила on 14.05.2022.
//

import Foundation

protocol MainPresenterProtocol: AnyObject {
    func showSearch()
    func showDetail(index: IndexPath)
    func delete(index: IndexPath)
    
    func fetchMovies()
    func getCountMovies() -> Int
    func getCellModel(index: IndexPath) -> CellModel
}

struct CellModel {
    let name: String
    var imageData: Data?
}

final class MainPresenter {
    weak var view: MainViewProtocol?
    private let router: RouterProtocol
    private let coreData: CoreDataProtocol
    
    private var myMovies: [MyMovie] = []
    
    // MARK: - Initialize Method
    init(router: RouterProtocol, coreData: CoreDataProtocol) {
        self.router = router
        self.coreData = coreData
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - MainPresenterProtocol
extension MainPresenter: MainPresenterProtocol {
    func showSearch() {
        router.showSearchModul()
    }
    
    func showDetail(index: IndexPath) {
        if let movie = myMovies[safe: index.row] {
            router.showDetailModul(movie: movie)
        }
    }
    
    func delete(index: IndexPath) {
        if let movie = myMovies[safe: index.row] {
            coreData.delete(movie)
        }
    }
    
    func getCountMovies() -> Int {
        return myMovies.count
    }
    
    func getCellModel(index: IndexPath) -> CellModel {
        let movie = myMovies[safe: index.row]
        var model = CellModel(name: movie?.name ?? "")
        model.imageData = movie?.imageData
        return model
    }
    
    func fetchMovies() {
        myMovies = coreData.fetchMovies()
        view?.reloadData()
    }
}
