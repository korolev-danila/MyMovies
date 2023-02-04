//
//  CoreDataManager.swift
//  MyMovies
//
//  Created by Данила on 04.02.2023.
//

import CoreData

protocol CoreDataProtocol {
    func fetchMovies() -> [MyMovie]
    func createMovie() -> MyMovie?
    func save()
    func delete(_ movie: MyMovie)
}

final class CoreDataManager {
    private let context: NSManagedObjectContext
    
    init( context: NSManagedObjectContext) {
        self.context = context
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - CoreDataProtocol
extension CoreDataManager: CoreDataProtocol {
    func fetchMovies() -> [MyMovie] {
        let fetchRequest: NSFetchRequest<MyMovie> = MyMovie.fetchRequest()
        var movies: [MyMovie] = []
        
        do {
            movies = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return movies
    }
    
    func createMovie() -> MyMovie? {
        guard let entity = NSEntityDescription.entity(forEntityName: "MyMovie", in: context) else { return nil}
        
        return MyMovie(entity: entity, insertInto: context)
    }
    
    func save() {
        do {
            try context.save()
            print("save context")
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func delete(_ movie: MyMovie) {
        context.delete(movie)
    }
}
