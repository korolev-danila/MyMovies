//
//  MovieModel .swift
//  ViewedMovies
//
//  Created by Данила on 14.05.2022.
//

import Foundation

struct MoviesModel: Decodable, Equatable {
    var search: [Movie]
    
    enum CodingKeys: String, CodingKey {
        case search = "Search"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.search = try container.decode([Movie].self, forKey: .search)
    }
}

struct Movie: Decodable, Equatable {
    var title: String
    var year: String
    var imdbID: String
    var poster: String
    var imageData: Data?
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID = "imdbID"
        case poster = "Poster"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.year = try container.decode(String.self, forKey: .year)
        self.imdbID = try container.decode(String.self, forKey: .imdbID)
        self.poster = try container.decode(String.self, forKey: .poster)
    }
}
