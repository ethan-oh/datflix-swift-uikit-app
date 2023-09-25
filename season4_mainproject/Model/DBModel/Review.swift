//
//  Review.swift
//  season4_mainproject
//
//  Created by Kang Hyeon Oh on 2023/09/25.
//

import Foundation

struct Review {
    var email : String?
    var nickname : String?
    var movie_id : Int
    var content : String
    var rating : Float
    var insertdate : String?
    var deletedate : String?
    
    init(email: String? = nil, nickname : String? = nil ,movie_id: Int, content: String, rating: Float, insertdate: String? = nil, deletedate: String? = nil) {
        self.email = email
        self.nickname = nickname
        self.movie_id = movie_id
        self.content = content
        self.rating = rating
        self.insertdate = insertdate
        self.deletedate = deletedate
    }
    
}
