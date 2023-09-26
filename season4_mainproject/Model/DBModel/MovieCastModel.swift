//
//  MovieCastModel.swift
//  season4_mainproject
//
//  Created by 박지환 on 2023/09/26.
//

import Foundation

struct MovieCastModel{
    var id: Int
    var imgpath: String
    var name: String
    var role: String

    
    init(id: Int, imgpath: String, name: String, role: String) {
        self.id = id
        self.imgpath = imgpath
        self.name = name
        self.role = role
    }
}
