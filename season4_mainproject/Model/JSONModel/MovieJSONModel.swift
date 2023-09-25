//
//  MovieJSONModel.swift
//  season4_mainproject
//
//  Created by TJ on 2023/09/25.
//

import Foundation

struct MovieJSONModel: Codable{
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
}
