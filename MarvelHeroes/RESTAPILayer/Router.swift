//
//  Router.swift
//  MarvelHeroes
//
//  Created by vit on 2/12/19.
//  Copyright © 2019 ket. All rights reserved.
//

import Foundation
import Alamofire

enum Router: URLRequestConvertible {
    
    case getHeroes(withLimit: Int, withOffset: Int)
    static let baseURLString = "https://gateway.marvel.com/v1/public/characters?"
    
    // define HTTP method
    var method: HTTPMethod {
        switch self {
        case .getHeroes:
            return .get
        }
    }
    
    // assembled web link
    var path: String {
        switch self {
        case .getHeroes(let limit, let offset):
            return "limit=\(limit)&offset=\(offset)&ts=1&apikey=7fcabde7c43d136312c02ddd457b5585&hash=59d26685428cdfe4e89e35ca8e90038a"
        }
    }
    
    // MARK: URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = try (Router.baseURLString + path).asURL()
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        
        return urlRequest
    }
}


