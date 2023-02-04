//
//  ModulBuilder.swift
//  ViewedMovies
//
//  Created by Данила on 14.05.2022.
//

import Foundation
import UIKit

protocol ModulBuilderProtocol {
    func createMainModule(router: RouterProtocol,
                          coreData: CoreDataProtocol) -> UIViewController
    func createSearchModule(router: RouterProtocol,
                            coreData: CoreDataProtocol) -> UIViewController
    func createDetailModule(router: RouterProtocol, movie: MyMovie,
                            coreData: CoreDataProtocol) -> UIViewController
}

final class ModulBuilder {}

// MARK: - ModulBuilderProtocol
extension ModulBuilder: ModulBuilderProtocol {
    func createMainModule(router: RouterProtocol, coreData: CoreDataProtocol) -> UIViewController {
        let presenter = MainPresenter(router: router, coreData: coreData)
        let view = MainViewController(presenter: presenter)
        presenter.view = view
        return view
    }
    
    func createSearchModule(router: RouterProtocol, coreData: CoreDataProtocol) -> UIViewController {
        let presenter = SearchPresenter(router: router, coreData: coreData)
        let view = SearchTableVC(presenter: presenter)
        presenter.view = view
        return view
    }
    
    func createDetailModule(router: RouterProtocol, movie: MyMovie, coreData: CoreDataProtocol) -> UIViewController {
        let presenter = DetailPresenter(router: router, coreData: coreData, movie: movie)
        let view = DetailViewController(presenter: presenter)
        presenter.view = view
        return view
    }
    
}
