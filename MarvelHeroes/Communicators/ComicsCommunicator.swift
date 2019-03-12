//
//  ComicsCommunicators.swift
//  MarvelHeroes
//
//  Created by vit on 3/7/19.
//  Copyright © 2019 ket. All rights reserved.
//

import Foundation
import Alamofire

struct ComicsCommunicator {
    
    static func getComics(withLimit limit: Int, withOffset offset: Int, completionHandler: @escaping (Result<ComicsDataWrapper>) -> Void) {
        Alamofire.request(Router.getComics(withLimit: limit, withOffset: offset)).responseJSON { response in
            if let data = response.data {
                do {
                    let decoder = JSONDecoder()
                    let receivedData = try decoder.decode(ComicsDataWrapper.self, from: data)
                    completionHandler(.success(receivedData))
                } catch {
                    print(error)
                    completionHandler(.failure(error))
                }
            }
        }
    }

    static func getSearchComics(withName name: String, completionHandler: @escaping (Result<ComicsDataWrapper>) -> Void ) {
        Alamofire.request(Router.getSearchComics(withTitle: name)).responseJSON {
            response in
            if let data = response.data {
                do {
                    let decoder = JSONDecoder()
                    let receivedData = try decoder.decode(ComicsDataWrapper.self, from: data)
                    completionHandler(.success(receivedData))
                } catch {
                    completionHandler(.failure(error))
                }
            }
        }
    }


}
