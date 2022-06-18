//
//  FilmModel.swift
//  MyMovies
//
//  Created by Данила on 17.05.2022.
//

import Foundation

struct Film {
    var name: String
    var year: String
    var imdbID: String
    var imageStr: String
    var imageData: Data?
    var rating: Int
    var watched: Bool
    var comment: String
    
    init() {
        name = ""
        year = ""
        imdbID = ""
        imageStr = "" 
        imageData = nil
        rating = 0
        watched = false
        comment = ""
    }
}
