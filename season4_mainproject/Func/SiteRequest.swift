//
//  SiteRequest.swift
//  season4_mainproject
//
//  Created by 김민성 on 2023/09/26.
//

import WebKit

class SiteRequest{
    func loadWebpage(url: String) -> URLRequest{
        let myUrl = URL(string: url)
        return URLRequest(url: myUrl!)
    }
}
