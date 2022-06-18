//
//  Router.swift
//  ViewedMovies
//
//  Created by Данила on 14.05.2022.
//

import Foundation
import UIKit
import CoreData

protocol RouterMain {
    var navigationController: UINavigationController? { get set }
    var modulBuilder: ModulBuilderProtocol? { get set }
    var context: NSManagedObjectContext { get set }
}

protocol RouterProtocol: RouterMain {
    func showMainModul()
    func showSearchModul()
    func showDetailModul(film: MyMovie)
    func popToRoot()
}

class Router: RouterProtocol {
    
    var navigationController: UINavigationController?
    var modulBuilder: ModulBuilderProtocol?
    var context: NSManagedObjectContext
    
    init(navigationController: UINavigationController, modulBuilder: ModulBuilderProtocol, context: NSManagedObjectContext) {
        self.navigationController = navigationController
        self.modulBuilder = modulBuilder
        self.context = context
    }
    
    func showMainModul() {
        if let navigationController = navigationController {
            guard let mainViewController =  modulBuilder?.createMainModule(router: self, navigationController: navigationController, context: context) else { return }
            navigationController.viewControllers = [mainViewController]
        }
    }
    
    func showSearchModul() {
        if let navigationController = navigationController {

            guard let searchVC = modulBuilder?.createSearchModule(router: self, navigationController: navigationController, context: context) else { return  }
            navigationController.pushViewController(searchVC, animated: true)
        }
    }
    
    func showDetailModul(film: MyMovie) {
        if let navigationController = navigationController {
            guard let detailViewController =  modulBuilder?.createDetailModule(router: self, navigationController: navigationController, film: film, context: context) else { return }
            navigationController.pushViewController(detailViewController, animated: true)
        }
    }
    
    func popToRoot() {        
        self.navigationController?.popToRootViewController(animated: true)
    }
}
