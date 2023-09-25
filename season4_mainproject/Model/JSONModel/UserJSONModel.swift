//
//  AuthJSONModel.swift
//  season4_mainproject
//
//  Created by TJ on 2023/09/25.
//

import Foundation

struct AuthJSONModel: Codable{
    var message: String
    var access_token: String
    var refresh_token: String

}

struct RegisterJSONModel: Codable{
    var message: String
    var email: String
}
