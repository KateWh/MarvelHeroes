

//
//  GetHeroes.swift
//  MarvelHeroes
//
//  Created by vit on 1/31/19.
//  Copyright © 2019 ket. All rights reserved.
//

import Foundation
import Alamofire

class HeroesViewModel {

    func getHeroes(withLimit limit: Int, withOffset offset: Int, completionHandler: @escaping (Result<CharacterDataWrapper>) -> Void) {
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
    
}
