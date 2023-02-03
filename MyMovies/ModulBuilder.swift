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
    func createSearchModule(router: RouterProtocol,  navigationController: UINavigationController,
                            context: NSManagedObjectContext) -> UIViewController
    func createDetailModule(router: RouterProtocol,  navigationController: UINavigationController, film: MyMovie,
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
    
    func createSearchModule(router: RouterProtocol, navigationController: UINavigationController, context: NSManagedObjectContext) -> UIViewController {
        let presenter = SearchPresenter(router: router, context: context)
        let view = SearchTableVC(presenter: presenter)
        presenter.view = view
        return view
    }
    
    func createDetailModule(router: RouterProtocol,  navigationController: UINavigationController, film: MyMovie, context: NSManagedObjectContext) -> UIViewController {
        let view = DetailViewController()
        let presenter = DetailPresenter(view: view, router: router, navigationController: navigationController, film: film, context: context)
        view.presenter = presenter
        return view
    }

}
