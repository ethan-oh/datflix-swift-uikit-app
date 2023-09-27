//
//  AuthJSONModel.swift
//  season4_mainproject
//
//  Created by TJ on 2023/09/25.
//

import Foundation

struct AuthJSON: Codable{
    var message: String
    var access_token: String
    var refresh_token: String
    var name: String
    var nickname: String

}

struct ResultJSON: Codable{
    var message: String
}

struct PasswordJSON: Codable{
    var current: String
    var new: String
}
