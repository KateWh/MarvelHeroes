//
//  CreatorsCommunicator.swift
//  MarvelHeroes
//
//  Created by vit on 3/7/19.
//  Copyright © 2019 ket. All rights reserved.
//

import Foundation
import Alamofire

struct CreatorsCommunicator {
    
    static func getCreators(withLimit limit: Int, withOffset offset: Int, completionHandler:
        @escaping (Result<CreatorsDataWrapper>) -> Void) {
        Alamofire.request(Router.getCreators(withLimit: limit, withOffset: offset)).responseJSON { response in
            if let data = response.data {
                do {
                    let decoder = JSONDecoder()
                    let receivedData = try decoder.decode(CreatorsDataWrapper.self, from: data)
                    completionHandler(.success(receivedData))
                } catch {
                    print(error)
                    completionHandler(.failure(error))
                }
            }
        }
    }

    static func getSearchCreators(withName name: String, completionHandler: @escaping (Result<CreatorsDataWrapper>) -> Void ) {
        Alamofire.request(Router.getSearchCreators(withName: name)).responseJSON {
            response in
            if let data = response.data {
                do {
                    let decoder = JSONDecoder()
                    let receivedData = try decoder.decode(CreatorsDataWrapper.self, from: data)
                    completionHandler(.success(receivedData))
                } catch {
                    completionHandler(.failure(error))
                }
            }
        }
    }

}
