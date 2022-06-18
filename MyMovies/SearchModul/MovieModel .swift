//
//  MovieModel .swift
//  ViewedMovies
//
//  Created by Данила on 14.05.2022.
//

import Foundation
import UIKit

struct MovieModel: Decodable, Equatable {
    var Search: [Movie]
}

struct Movie: Decodable, Equatable {
    var Title: String
    var Year: String
    var imdbID: String
    var Poster: String
}
