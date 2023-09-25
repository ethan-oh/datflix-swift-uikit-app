//
//  ReviewController.swift
//  season4_mainproject
//
//  Created by Kang Hyeon Oh on 2023/09/25.
//

import Foundation

class ReviewController {
    var service : ReviewService
    
    init(service: ReviewService) {
        self.service = service
    }
    
    func insertReview(movie_id: Int, content: String, rating : Float) -> Bool {
        var result :  Bool = true
        if !self.service.insertModel(movie_id: movie_id, content: content, rating: rating) {
            result = false
        }
        return result
    }
    
    func selectReview(movie_id: Int, completion: @escaping ([Review]) -> Void) {
        self.service.readModel(movie_id: movie_id) { reviews in
            completion(reviews)
        }
    }
    
    func updateReview(movie_id: Int, content: String, rating : Float) -> Bool {
        var result :  Bool = true
        if !self.service.updateModel(movie_id: movie_id, content: content, rating: rating) {
            result = false
        }
        return result
    }
    
    func deleteReview(movie_id: Int) -> Bool {
        var result :  Bool = true
        if !self.service.deleteModel(movie_id: movie_id) {
            result = false
        }
        return result
    }
}
