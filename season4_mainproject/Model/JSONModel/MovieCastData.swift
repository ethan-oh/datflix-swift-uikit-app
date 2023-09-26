//
//  MovieCastData.swift
//  season4_mainproject
//
//  Created by 박지환 on 2023/09/26.
//

import Foundation
struct MovieCastData: Decodable {
    let result: [MovieCast]
}


struct MovieCast: Decodable {
    let id: Int
    let imgpath: String
    let name: String
    let role: String
}
