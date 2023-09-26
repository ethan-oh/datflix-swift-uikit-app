//
//  MovieData.swift
//  season4_mainproject
//
//  Created by 박지환 on 2023/09/25.
//

import Foundation
// MovieData 구조체 정의
struct MovieData: Decodable {
    let result: [Movie]
}

struct Movie: Decodable {
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
