//
//  ModulBuilder.swift
//  ViewedMovies
//
//  Created by Данила on 14.05.2022.
//

import Foundation
import UIKit
import CoreData

protocol ModulBuilderProtocol {
    func createMainModule(router: RouterProtocol,  navigationController: UINavigationController, context: NSManagedObjectContext) -> UIViewController
    func createSearchModule(router: RouterProtocol,  navigationController: UINavigationController, context: NSManagedObjectContext) -> UIViewController
    func createDetailModule(router: RouterProtocol,  navigationController: UINavigationController, film: MyMovie, context: NSManagedObjectContext) -> UIViewController
}

class ModulBuilder: ModulBuilderProtocol {
    
    func createMainModule(router: RouterProtocol, navigationController: UINavigationController, context: NSManagedObjectContext) -> UIViewController {
        let view = MainViewController()
        let presenter = MainPresenter(view: view, router: router, navigationController: navigationController, context: context)
        view.presenter = presenter
        return view
    }
    
    func createSearchModule(router: RouterProtocol, navigationController: UINavigationController, context: NSManagedObjectContext) -> UIViewController {
        let view = SearchTableVC()
        let presenter = SearchPresenter(view: view, router: router, navigationController: navigationController, context: context )
        view.presenter = presenter
        return view
    }
    
    func createDetailModule(router: RouterProtocol,  navigationController: UINavigationController, film: MyMovie, context: NSManagedObjectContext) -> UIViewController {
        let view = DetailViewController()
        let presenter = DetailPresenter(view: view, router: router, navigationController: navigationController, film: film, context: context)
        view.presenter = presenter
        return view
    }

}
