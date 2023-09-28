//
//  AuthModel.swift
//  season4_mainproject
//
//  Created by TJ on 2023/09/25.
//

import Foundation

struct tokenModel{
    var message: String
    var name: String
    var nickname: String
    
    init(message: String, name: String, nickname: String) {
        self.message = message
        self.name = name
        self.nickname = nickname
    }
}
