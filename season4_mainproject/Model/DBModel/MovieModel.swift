//
//  MovieModel.swift
//  season4_mainproject
//
//  Created by TJ on 2023/09/25.
//

import Foundation

struct MovieModel{
    var id: Int
    var ott: String
    var title: String
    var imagepath: String
    var releasedate: String
    var genre: String
    var totalaudience: Int
    var contry: String
    var rating: String
    var star: Int
    var runningtime: Int
    var summary: String
    
    init(id: Int, ott: String, title: String, imagepath: String, releasedate: String, genre: String, totalaudience: Int, contry: String, rating: String, star: Int, runningtime: Int, summary: String) {
        self.id = id
        self.ott = ott
        self.title = title
        self.imagepath = imagepath
        self.releasedate = releasedate
        self.genre = genre
        self.totalaudience = totalaudience
        self.contry = contry
        self.rating = rating
        self.star = star
        self.runningtime = runningtime
        self.summary = summary
    }
}

