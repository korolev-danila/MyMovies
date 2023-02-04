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
    private let coreData: CoreDataProtocol
    
    init(navigationController: UINavigationController, modulBuilder: ModulBuilderProtocol, coreData: CoreDataProtocol) {
        self.navigationController = navigationController
        self.modulBuilder = modulBuilder
        self.coreData = coreData
    }
}

extension Router: RouterProtocol {
    
    public func showMainModul() {
        let mainViewController =  modulBuilder.createMainModule(router: self,
                                                                coreData: coreData)
        navigationController.viewControllers = [mainViewController]
    }
    
    public func showSearchModul() {
        let searchVC = modulBuilder.createSearchModule(router: self,
                                                       coreData: coreData)
        navigationController.pushViewController(searchVC, animated: true)
    }
    
    public func showDetailModul(movie: MyMovie) {
        let detailViewController =  modulBuilder.createDetailModule(router: self , movie: movie, coreData: coreData)
        navigationController.pushViewController(detailViewController, animated: true)
    }
    
    public func popToRoot() {
        navigationController.popToRootViewController(animated: true)
    }
}
