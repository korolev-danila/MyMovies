//
//  Router.swift
//  ViewedMovies
//
//  Created by Данила on 14.05.2022.
//

import UIKit
import CoreData

protocol RouterProtocol {
    func showMainModul()
    func showSearchModul()
    func showDetailModul(movie: MyMovie)
    func popToRoot()
}

final class Router {
    private let navigationController: UINavigationController
    private let modulBuilder: ModulBuilderProtocol
    private let context: NSManagedObjectContext
    
    init(navigationController: UINavigationController, modulBuilder: ModulBuilderProtocol, context: NSManagedObjectContext) {
        self.navigationController = navigationController
        self.modulBuilder = modulBuilder
        self.context = context
    }
}

extension Router: RouterProtocol {
    
    public func showMainModul() {
        let mainViewController =  modulBuilder.createMainModule(router: self,
                                                                context: context)
        navigationController.viewControllers = [mainViewController]
    }
    
    public func showSearchModul() {
        let searchVC = modulBuilder.createSearchModule(router: self,
                                                       context: context)
        navigationController.pushViewController(searchVC, animated: true)
    }
    
    public func showDetailModul(movie: MyMovie) {
        let detailViewController =  modulBuilder.createDetailModule(router: self , movie: movie, context: context)
        navigationController.pushViewController(detailViewController, animated: true)
    }
    
    public func popToRoot() {
        navigationController.popToRootViewController(animated: true)
    }
}
