//
//  AuthModel.swift
//  season4_mainproject
//
//  Created by TJ on 2023/09/25.
//

import Foundation

struct tokenModel{
    var message: String
    var access_token: String
    var refresh_token: String
    var nickname: String
    var name: String
    
    init(message: String, access_token: String, refresh_token: String, nickname: String, name: String) {
        self.message = message
        self.access_token = access_token
        self.refresh_token = refresh_token
        self.nickname = nickname
        self.name = name
    }
}
