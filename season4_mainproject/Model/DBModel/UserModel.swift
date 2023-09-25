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
    
    init(message: String, access_token: String, refresh_token: String) {
        self.message = message
        self.access_token = access_token
        self.refresh_token = refresh_token
    }
}
