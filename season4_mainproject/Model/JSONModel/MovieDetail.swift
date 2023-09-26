//
//  MovieDetail.swift
//  season4_mainproject
//
//  Created by 박지환 on 2023/09/26.
//

import Foundation
struct MovieDetail: Codable {
    let result: MovieDetailModel
}

struct MovieDetailModel: Codable {
    let id: Int
    let ott: String
    let title: String
    let imagepath: String
    let releasedate: String
    let genre: String
    let totalaudience: Int
    let country: String
    let rating: String
    let star: Float
    let runningtime: Int
    let summary: String
}
