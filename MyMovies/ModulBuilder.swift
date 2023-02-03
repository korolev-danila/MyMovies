//
//  ModulBuilder.swift
//  ViewedMovies
//
//  Created by Данила on 14.05.2022.
//

import UIKit
import CoreData

protocol ModulBuilderProtocol {
    func createMainModule(router: RouterProtocol,
                          context: NSManagedObjectContext) -> UIViewController
    func createSearchModule(router: RouterProtocol,
                            context: NSManagedObjectContext) -> UIViewController
    func createDetailModule(router: RouterProtocol, movie: MyMovie,
                            context: NSManagedObjectContext) -> UIViewController
}

final class ModulBuilder {}

// MARK: - ModulBuilderProtocol
extension ModulBuilder: ModulBuilderProtocol {
    func createMainModule(router: RouterProtocol, context: NSManagedObjectContext) -> UIViewController {
        let presenter = MainPresenter(router: router, context: context)
        let view = MainViewController(presenter: presenter)
        presenter.view = view
        return view
    }
    
    func createSearchModule(router: RouterProtocol, context: NSManagedObjectContext) -> UIViewController {
        let presenter = SearchPresenter(router: router, context: context)
        let view = SearchTableVC(presenter: presenter)
        presenter.view = view
        return view
    }
    
    func createDetailModule(router: RouterProtocol, movie: MyMovie, context: NSManagedObjectContext) -> UIViewController {
        let presenter = DetailPresenter(router: router, context: context, movie: movie)
        let view = DetailViewController(presenter: presenter)
        presenter.view = view
        return view
    }
    
}
