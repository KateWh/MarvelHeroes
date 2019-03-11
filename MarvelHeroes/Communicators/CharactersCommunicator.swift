//
//  CharactersCommunicator.swift
//  MarvelHeroes
//
//  Created by ket on 13.02.2019.
//  Copyright © 2019 ket. All rights reserved.
//

import Foundation
import Alamofire

struct CharatersCommunicator {

    static func getHeroes(withLimit limit: Int, withOffset offset: Int, completionHandler: @escaping (Result<CharacterDataWrapper>) -> Void) {
        Alamofire.request(Router.getHeroes(withLimit: limit, withOffset: offset)).responseJSON { response in
            if let data = response.data {
                do {
                    let decoder = JSONDecoder()
                    let receivedData = try decoder.decode(CharacterDataWrapper.self, from: data)
                    completionHandler(.success(receivedData))
                } catch {
                    print(error)
                    completionHandler(.failure(error))
                }
            }
        }
    }

    static func getSearchHero(withName name: String, completionHandler: @escaping (Result<CharacterDataWrapper>) -> Void ) {
        Alamofire.request(Router.getSearchHero(withName: name)).responseJSON {
            response in
            if let data = response.data {
                do {
                    let decoder = JSONDecoder()
                    let receivedData = try decoder.decode(CharacterDataWrapper.self, from: data)
                    completionHandler(.success(receivedData))
                } catch {
                    completionHandler(.failure(error))
                }
            }
        }
    }

}
